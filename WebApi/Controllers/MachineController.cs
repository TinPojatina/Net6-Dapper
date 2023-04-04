using Microsoft.AspNetCore.Mvc;
using WebApi.Models;
using Dapper;
using Npgsql;

namespace WebApi.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class MachinesController : ControllerBase
    {
        private readonly IConfiguration _config;
        public MachinesController(IConfiguration config)
        {
            _config = config;
        }

        [HttpGet("getMachines")]
        public async Task<ActionResult<List<Machine>>> GetAllMachines()
        {
            using var connection = new NpgsqlConnection(_config.GetConnectionString("DefaultConnection"));
            IEnumerable<Machine> machines = await SelectAllMachines(connection);
            return Ok(machines);

        }

        private static async Task<IEnumerable<Machine>> SelectAllMachines(NpgsqlConnection connection)
        {
            return await connection.QueryAsync<Machine>("SELECT * FROM MACHINES");
        }

        [HttpGet("getMachine/{id}")]
        public async Task<ActionResult<Machine>> GetMachine(int id)
        {
            using var connection = new NpgsqlConnection(_config.GetConnectionString("DefaultConnection"));
            Machine machine = await SelectMachine(id, connection);
            return Ok(machine);

        }

        private static async Task<Machine> SelectMachine(int id, NpgsqlConnection connection)
        {
            return await connection.QueryFirstAsync<Machine>("SELECT NAME FROM MACHINES WHERE id = @Id", new { Id = id });
        }

        [HttpPost("newMachine")]
        public async Task<IActionResult> NewMachine(Machine machine)
        {
            using var connection = new NpgsqlConnection(_config.GetConnectionString("DefaultConnection"));
            var existingMachine = await connection.QuerySingleOrDefaultAsync<Machine>("SELECT * FROM MACHINES WHERE Name = @Name", new { machine.Name });
            if (existingMachine != null)
            {
                return Conflict("Machine with the same name already exists");
            }
            await connection.ExecuteAsync("INSERT INTO MACHINES (Name) Values (@Name)", machine);
            return Ok(machine);
        }

        [HttpPut("updateMachine")]
        public async Task<ActionResult<Machine>> UpdateMachine(Machine machine)
        {
            using var connection = new NpgsqlConnection(_config.GetConnectionString("DefaultConnection"));
            await connection.ExecuteAsync("UPDATE MACHINES SET name = @Name WHERE id = @Id",  machine);
            return Ok(await SelectMachine(machine.Id, connection));
            
        }


        [HttpGet("Machine-Malfunctions-And-Average-Duration/{id}")]
        public async Task<ActionResult<MyResponse>> MalfunctionInfo(int id)
        {
            using var connection = new NpgsqlConnection(_config.GetConnectionString("DefaultConnection"));
            var machineName = SelectMachine(id, connection);
            var malfunctions = await connection.QueryAsync<Machine>("SELECT * FROM Malfunctions WHERE id = @Id AND IsFixed = true", new { Id = id });
            var averageDuration = AverageDuration((List<Malfunction>)malfunctions);
            var newResponse = new MyResponse(machineName, malfunctions, averageDuration);
            return Ok(newResponse);
        }


        private async Task<ActionResult<Double>> AverageDuration(List<Malfunction> malfunctions)
        {
            double totalDuration = 0;
            double malfunctionCount = 0;

            foreach (var malfunction in malfunctions)
            {
                TimeSpan duration = malfunction.EndTime.Value - malfunction.StartTime;
                totalDuration += duration.TotalHours;
                malfunctionCount++;
            }

            if (malfunctionCount == 0)
            {
                return Ok(0);
            }

            double averageDuration = totalDuration / malfunctionCount;
            return Ok(averageDuration);

        }
        public class MyResponse
        {
            private IEnumerable<Machine> malfunctions;
            private Task<ActionResult<double>> averageDuration1;
            private Task<Machine> machineName;
            private Task<ActionResult<double>> averageDuration;

            public MyResponse(Task<Machine> machineName, IEnumerable<Machine> malfunctions, Task<ActionResult<double>> averageDuration)
            {
                this.machineName = machineName;
                this.malfunctions = malfunctions;
                this.averageDuration = averageDuration;
            }
        }

    }
}