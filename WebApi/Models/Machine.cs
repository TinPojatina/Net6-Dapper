namespace WebApi.Models
{
    public class Machine
    {
        public int Id { get; set; }
        public string Name { get; set; }

        public List<Malfunction> Malfunctions { get; set; } = new List<Malfunction>();
    }
}

