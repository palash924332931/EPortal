using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Report
{
   

    [Table("DMMolecule")]
    public class MoleculeDetail
    {
        [Key]
        public int FCC { get; set; }
        [NotMapped]
        public string MoleculeId { get; set; }
        public string Molecule { get; set; }

        //public int Synonym { get; set; }
        public byte Synonym { get; set; }

        public int Parent { get; set; }

        public string Description { get; set; }
    }
}