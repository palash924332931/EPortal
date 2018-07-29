using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.AuditReport
{
    /// <summary>
    /// Generates difference report between territories for the version range selected
    /// </summary>
    public class TerritoryReport : IAuditReport
    {
        private EverestPortalContext _db = new EverestPortalContext();
        public dynamic GenerateReport(int Id, int startversion, int endVersion, string report)
        {
            //get the territories between versions selected
            var result = _db.Territories_History.Where(i => i.TerritoryId == Id).Where(x => x.Version >= startversion && x.Version <= endVersion).ToList();
            

            TerritoryReportDTO dto = new TerritoryReportDTO();


            //add the comparision fields which might have changed at terrtiory level
            List<string> nameChangeParm = new List<string>() { "Name", "LD", "AD", "SRA_Client", "SRA_Suffix" };
            //add the comparision fields which might have changed at allocation level
            List<string> settingsChangeParm = new List<string>() { "BrickOutletCode", "BrickOutletName", "NodeName", "NodeCode" };
            dto.TerritoryAllocationChanges = new List<TerritoryAllocationChangeDTO>();

            if (result.Count > 1)
            {
                for (int i = 1; i < result.Count; i++)
                {
                    var item1 = result[i - 1];
                    var item2 = result[i];
                    var diffList = item1.GetObjectDifference(item2, nameChangeParm);
                    var userDetail1 = _db.Users.Where(a => a.UserID == item1.UserId).FirstOrDefault();
                    var userDetail2 = _db.Users.Where(a => a.UserID == item2.UserId).FirstOrDefault();
                    var tempList1 = result[i - 1].OutletBrickAllocations;
                    var tempList2 = result[i].OutletBrickAllocations;

                    var groupsList1 = result[i - 1].Groups;
                    var groupsList2 = result[i].Groups;

                    if (report == "Name and Id Changes")
                    {                        

                        if (diffList.Count >= 1)
                        {
                            TerritoryChangeDTO diff = new TerritoryChangeDTO();
                            diff.TerritoryDefinitionName = item1.Name; diff.LD = item1.LD; diff.AD = item1.AD; diff.SRAClient = item1.SRA_Client; diff.SRASuffix = item1.SRA_Suffix;
                            diff.VersionNumber = item1.Version;
                            diff.SubmittedBy = userDetail1.FirstName + " " + userDetail1.LastName;
                            diff.DateTime = item1.ModifiedDate.ToString("yyyy-MM-dd hh:mm:ss");
                            if (dto.TerritoryDefinitionChanges == null)
                            {
                                dto.TerritoryDefinitionChanges = new List<TerritoryChangeDTO>();
                                dto.TerritoryDefinitionChanges.Add(diff);
                            }

                            diff = new TerritoryChangeDTO();
                            diff.TerritoryDefinitionName = item2.Name; diff.LD = item2.LD; diff.AD = item2.AD; diff.SRAClient = item2.SRA_Client; diff.SRASuffix = item2.SRA_Suffix;
                            diff.VersionNumber = item2.Version;
                            diff.SubmittedBy = userDetail2.FirstName + " " + userDetail2.LastName;
                            diff.DateTime = item2.ModifiedDate.ToString("yyyy-MM-dd hh:mm:ss");
                            dto.TerritoryDefinitionChanges.Add(diff);
                        }
                    }
                    else if (report == "Allocation Changes")
                    {


                        var deletedItem = tempList1.Where(a => !tempList2.Any(a1 => a1.BrickOutletCode == a.BrickOutletCode)).ToList();
                        var insertedItem = tempList2.Where(a => !tempList1.Any(a1 => a1.BrickOutletCode == a.BrickOutletCode)).ToList();

                        foreach (OutletBrickAllocations_History OBA1 in deletedItem)
                        {
                            dto.TerritoryAllocationChanges.Add(new TerritoryAllocationChangeDTO()
                            {
                                BrickOrOutletCode = OBA1.BrickOutletCode,
                                BrickOrOutletName = OBA1.BrickOutletName,
                                DateTime = result[i].ModifiedDate.ToString("yyyy-MM-dd hh:mm:ss"),
                                VersionNumber = result[i].Version,
                                ID = OBA1.NodeCode,
                                Group = OBA1.NodeName,
                                SubmittedBy = userDetail2.FirstName + " " + userDetail2.LastName,
                                Action = "Deleted",
                                ParentGroups = FlattenGroup(item1.Groups.FirstOrDefault(g => g.CustomGroupNumberSpace == OBA1.NodeCode))
                            });
                        }


                        foreach (OutletBrickAllocations_History OBA2 in insertedItem)
                        {
                            dto.TerritoryAllocationChanges.Add(new TerritoryAllocationChangeDTO()
                            {
                                BrickOrOutletCode = OBA2.BrickOutletCode,
                                BrickOrOutletName = OBA2.BrickOutletName,
                                DateTime = result[i].ModifiedDate.ToString("yyyy-MM-dd hh:mm:ss"),
                                VersionNumber = result[i].Version,
                                ID = OBA2.NodeCode,
                                Group = OBA2.NodeName,
                                SubmittedBy = userDetail2.FirstName + " " + userDetail2.LastName,
                                Action = "Added",
                                ParentGroups = FlattenGroup(item2.Groups.FirstOrDefault(g => g.CustomGroupNumberSpace == OBA2.NodeCode))

                            });
                        }
                    }
                    else if (report == "Group Changes")
                    {

                        if (dto.TerritoryGroupChanges == null) dto.TerritoryGroupChanges = new List<TerritoryGroupChangeDTO>();
                        var deletedItem = groupsList1.Where(a => !groupsList2.Any(a1 => a1.GroupNumber == a.GroupNumber)).ToList();
                        var insertedItem = groupsList2.Where(a => !groupsList1.Any(a1 => a1.GroupNumber == a.GroupNumber)).ToList();
                        var editedItem = groupsList2.Where(a => groupsList1.Any(a1 => a1.GroupNumber == a.GroupNumber))
                            .Where(a => !groupsList1.Any(a1 => a1.Name == a.Name)).ToList();

                        foreach (Groups_History gp1 in deletedItem)
                        {
                            dto.TerritoryGroupChanges.Add(new TerritoryGroupChangeDTO()
                            {
                                GroupNames = gp1.Name,
                                DateTime = result[i].ModifiedDate.ToString("yyyy-MM-dd hh:mm:ss"),
                                VersionNumber = result[i].Version,
                                ID = gp1.CustomGroupNumberSpace,                                
                                SubmittedBy = userDetail2.FirstName + " " + userDetail2.LastName,
                                Action = "Deleted",
                                ParentGroups = FlattenGroup(gp1)
                            });
                        }


                        foreach (Groups_History gp2 in insertedItem)
                        {
                            dto.TerritoryGroupChanges.Add(new TerritoryGroupChangeDTO()
                            {
                                GroupNames = gp2.Name,
                                DateTime = result[i].ModifiedDate.ToString("yyyy-MM-dd hh:mm:ss"),
                                VersionNumber = result[i].Version,
                                ID = gp2.CustomGroupNumberSpace,                                
                                SubmittedBy = userDetail2.FirstName + " " + userDetail2.LastName,
                                Action = "Added",
                                ParentGroups = FlattenGroup(gp2)

                            });
                        }

                        foreach (Groups_History gp3 in editedItem)
                        {
                            dto.TerritoryGroupChanges.Add(new TerritoryGroupChangeDTO()
                            {
                                GroupNames = gp3.Name,
                                DateTime = result[i].ModifiedDate.ToString("yyyy-MM-dd hh:mm:ss"),
                                VersionNumber = result[i].Version,
                                ID = gp3.CustomGroupNumberSpace,
                                SubmittedBy = userDetail2.FirstName + " " + userDetail2.LastName,
                                Action = "Edited",
                                ParentGroups = FlattenGroup(gp3)

                            });
                        }
                    }
                }
            }

            return dto;
        }

        private string FlattenGroup(Groups_History group)
        {
            string groupsName = "";
            
            while (group.ParentId != null) {
                Groups_History parent = group.Territory.Groups.FirstOrDefault(g => g.GroupId == group.ParentId);
                groupsName = groupsName != "" ? parent.Name + ", " + groupsName : parent.Name;
                group = parent;
            }

            return groupsName;
        }
    }


}