namespace WebApi.Models
{
    public class Malfunction
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int MachineId { get; set; }
        public string Priority { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public string Description { get; set; }
        public bool IsFixed { get; set; }

    }


}