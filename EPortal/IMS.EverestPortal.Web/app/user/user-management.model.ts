export class User
{
    UserID: number;
    UserName: string;
    FirstName: string;
    LastName: string;
    Email: string;
    IsActive: boolean;
    UserTypeID: number;
    Password: string;
    RoleID: number;
    RoleName: string;
    MaintenancePeriodEmail: boolean;
    NewsAlertEmail: boolean;
    ClientID: number;
    PasswordCreatedDate: Date;
    IsPasswordVerified: boolean;
    FailedPasswordAttempt: number;
    ActionUser: number;
}
export class Role
{
    RoleID: number;
    RoleName: string;
    IsExternal: boolean;
}
export class Client {
    Id: number;
    Name: string;
}

