using Microsoft.AspNetCore.Mvc;
using WebApi.Models;
using Dapper;
using Npgsql;

namespace WebApi.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class MalfunctionController : ControllerBase
    {
        private readonly IConfiguration _config;
        public MalfunctionController(IConfiguration config)
        {
            _config = config;
        }

        [HttpGet("Get-All-Malfunctions")]
        public async Task<ActionResult<List<Machine>>> GetAllMalfunctions()
        {
            using var connection = new NpgsqlConnection(_config.GetConnectionString("DefaultConnection"));
            var malfunctions = await connection.QueryAsync<Malfunction>("SELECT * FROM MALFUNCTIONS");
            return Ok(malfunctions);
        }

        [HttpPost("New-Malfunction")]
        public async Task<IActionResult> AddMalfunction(Malfunction malfunction)
        {
            using var connection = new NpgsqlConnection(_config.GetConnectionString("DefaultConnection"));
            var unfixedMalfunctions = await connection.QueryAsync<Malfunction>("SELECT * FROM MALFUNCTIONS WHERE MachineId = @MachineId AND IsFixed = @Status", new { malfunction.MachineId, Status = false });
            if (unfixedMalfunctions.Any())
            {
                return Conflict("Machine already has an unfixed malfunction");
            }
            if (string.IsNullOrEmpty(malfunction.Description))
            {
                return BadRequest("Malfunction description cannot be empty");
            }
            await connection.ExecuteAsync("INSERT INTO MALFUNCTIONS (MachineId, Name, Priority, StartTime, EndTime, Description, Status) VALUES (@MachineId, @Name, @Priority, @StartTime, @EndTime, @Description, @Status)", malfunction);
            return Ok(malfunction);
        }

        [HttpGet("Sorted-Paginated-malfunctions/{machineId}/{pageNumber}/{pageSize}")]
        public async Task<ActionResult<List<Malfunction>>> GetMalfunctions(int machineId, int pageSize, int pageNumber)
        {
            using var connection = new NpgsqlConnection(_config.GetConnectionString("DefaultConnection"));
            var offset = pageSize * (pageNumber - 1);
            var malfunctions = await connection.QueryAsync<Malfunction>("SELECT * FROM Malfunctions WHERE MachineId = @MachineId ORDER BY Priority ASC, StartTime DESC OFFSET @Offset LIMIT @PageSize"
                , new { MachineId = machineId, Offset = offset, PageSize = pageSize });
            return Ok(malfunctions);
        }

        [HttpGet("Get-Malfunctions/{id}")]
        public async Task<ActionResult<List<Malfunction>>> GetMalfunctions(int id)
        {
            using var connection = new NpgsqlConnection(_config.GetConnectionString("DefaultConnection"));
            var malfunctions = await connection.QueryAsync<List<Malfunction>>("SELECT * FROM Malfunctions WHERE MachineId = @MachineId", new { MachineId = id });
            return Ok(malfunctions);
        }

        [HttpPut("Change-Malfunction-Status/{machineId}")]
        public async Task<ActionResult<Malfunction>> ChangeStatus(int machineId)
        {
            using var connection = new NpgsqlConnection(_config.GetConnectionString("DefaultConnection"));
            await connection.ExecuteAsync("UPDATE Malfunctions SET IsFixed = WHEN IsFixed = true THEN false ELSE true END WHERE MachineId = @id", new { id = machineId});
            return Ok(GetMalfunctions(machineId));
        }
    }
}
