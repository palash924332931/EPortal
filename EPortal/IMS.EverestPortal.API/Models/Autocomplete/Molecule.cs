using SolrNet.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class Molecule
    {
        [SolrUniqueKey("Molecule")]
        public int MoleculeId { get; set; }
        
        [SolrField("Synonym")]        
        public int Synonym { get; set; }

        [SolrField("Parent")]
        public int Parent { get; set; }

        [SolrField("Description")]
        public string Description { get; set; }
    }
}