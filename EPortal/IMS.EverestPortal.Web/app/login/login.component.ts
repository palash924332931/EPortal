import { Component, OnInit, ViewChild } from '@angular/core';
import { CookieService } from 'angular2-cookie/services/cookies.service';
//import { users } from '../shared/models/mock-clients';
import { User,Password } from '../shared/model';
//import { EmailValidator } from 'ng2-validation/dist/email';
//import {   Validators } from '@angular/forms';
import { LoginService } from './login.service';
import { ModalDirective } from 'ng2-bootstrap';
import { CommonService } from '../shared/common';
import { Router, ActivatedRoute } from '@angular/router';

declare var jQuery: any;
@Component({
    selector: 'login-component',
    templateUrl: '../../app/login/login.component.html',
    providers: [LoginService]

})
export class loginComponent implements OnInit{
    @ViewChild('lgModalLogin') lgModalLogin: ModalDirective
    @ViewChild('replyModal') replyModal: ModalDirective
    userName: string = "";
    passwd: string = "";
    rememeberMe: boolean;
    isForgotPasswordVisible: boolean = false;
    isResetPasswordVisible: boolean = false;
    userNameForForgotPwd: string = "";
    userNameForResetPwd: string = "";
    passwordForResetPwd: string = "";
    confirmPasswordForResetPwd: string = "";
    resetToken: string = "";
    //emailMsg: string = "";
    //pwdMsg: string = "";
    currentUser: User[]=[];
    isClickedOnce: boolean = false;
    emailAddress: string = "lcao@au.imshealth.com";
    errorMessage: string = "";
    isResetButtonDisabled: boolean = false;
    isPasswordResetDisabled: boolean = false;

    ngOnInit(): void {
        //not working well
        //var email = this._cookieService.get('EmailId');
        //if (email != undefined) {
        //    this.rememeberMe = true;
        //    this.userName = email;
        //}

        jQuery("#email").unbind();
        jQuery("#email").bind("keyup", function () {
            jQuery("#EmailErr").html("");
            jQuery("#LoginErr").html("");
            jQuery("#userErr").html("");
        });

        jQuery("#pwd").unbind();
        jQuery("#pwd").bind("keyup", function () {
            jQuery("#PwdErr").html("");
            jQuery("#LoginErr").html("");
            jQuery("#userErr").html("");
        });

        jQuery("#LoginErr").html("");
        jQuery("#userErr").html("");
        
        // pull data saved using rememeberMe
        let userInfo= localStorage.getItem("everest-client-portal-rememeberMe");
        if(userInfo==null){
            this.rememeberMe=false;
            this.userName="";
        }else{
            this.rememeberMe=true;
            this.userName=JSON.parse(userInfo).Name;
        }
        this.displayResetPassword();
    }

    displayResetPassword(): void {
        this.resetToken = this.getParameterByName("resettoken");
        if (this.resetToken !== null && this.resetToken !== '') {
            this.isResetPasswordVisible = true;
            this._loginService.getUsernameForResetToken(this.resetToken).subscribe(response => {
                if (response.isExist === false) {
                    jQuery("#ResetPwdErr").html("Invalid password reset token.");
                    this.isResetButtonDisabled = true;
                }
                else {
                    this.userNameForResetPwd = response.username;
                    this.isResetButtonDisabled = false;
                }
            },
                e => {
                    console.log(e);
                });
        }
    }

    getParameterByName(name: string): string {
        let url = window.location.href;
        name = name.replace(/[\[\]]/g, "\\$&");
        var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
            results = regex.exec(url);
        if (!results) return null;
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, " "));
    }

    SendPasswordResetEmail(): boolean {
        if (this.userNameForForgotPwd == "") {
            jQuery("#EmailForForgotErr").html("This information is required.");
            jQuery("#emailForForgotPwd").focus();
            return false;
        }
        else {
            jQuery("#EmailForForgotErr").html("");
            jQuery("#SendPwdForForgotErr").html("");
            jQuery("#SendPwdForForgotSuccess").html("");
            this.isPasswordResetDisabled = true;
            this._loginService.SendPasswordResetEmail(this.userNameForForgotPwd).subscribe(
                response => {
                    if (response.isSuccess) {
                        jQuery("#SendPwdForForgotErr").html("");
                        jQuery("#SendPwdForForgotSuccess").html(response.message);
                    }
                    else {
                        jQuery("#SendPwdForForgotSuccess").html("");
                        jQuery("#SendPwdForForgotErr").html(response.message);
                        setTimeout(function () {
                            jQuery("#SendPwdForForgotErr").html("");
                        }, 5000);
                    }
                    this.isPasswordResetDisabled = false;
                },
                err => {
                }
            );
        }
    }

    resetPassword(): boolean {
        if (this.validatePassword()) {
            this._loginService.changePasswordByResetToken(this.resetToken, this.passwordForResetPwd).subscribe(response => {
                if (response.isSuccess) {
                    jQuery("#ResetPwdSuccess").html("Your password has been changed. Please click on Login.");
                    jQuery("#ResetPwdErr").html("");
                }
                else {
                    jQuery("#ResetPwdSuccess").html("");
                    jQuery("#ResetPwdErr").html(response.message);
                }
                jQuery("#PwdForResetPwdErr").html("");
                jQuery("#PwdForResetPwdErr").html("");
                jQuery("#ConfirmPwdForResetPwdErr").html("");
            }, err => {

            });
            return true;
        }
        return false;
    }

    redirectToLogin(): void {
        this.isResetPasswordVisible = false;
        this.router.navigateByUrl("/");
    }

    validatePassword(): boolean {
        if (this.passwordForResetPwd == "") {
            jQuery("#PwdForResetPwdErr").html("This information is required.");
            jQuery("#pwdForResetPwd").focus();
            return false;
        } else if (this.passwordForResetPwd.length < 8) {
            jQuery("#PwdForResetPwdErr").html("Minimum 8 characters are required for the new password.");
            jQuery("#pwdForResetPwd").focus();
            return false;
        } else if (this.passwordForResetPwd.length > 25) {
            jQuery("#PwdForResetPwdErr").html("Maximum 25 characters are required for the new password.");
            jQuery("#pwdForResetPwd").focus();
            return false;
        } else if (this.validateRegExp(this.passwordForResetPwd) === false) {
            jQuery("#PwdForResetPwdErr").html("Password must contain characters from at least three of the following character types i.e. lowercase letters, uppercase letters, numbers and symbols.");
            jQuery("#pwdForResetPwd").focus();
            return false;
        } else if (this.confirmPasswordForResetPwd == "") {
            jQuery("#PwdForResetPwdErr").html("");
            jQuery("#ConfirmPwdForResetPwdErr").html("This information is required.");
            jQuery("#conpwdForResetPwd").focus();
            return false;
        } else if (this.passwordForResetPwd != this.confirmPasswordForResetPwd) {
            jQuery("#PwdForResetPwdErr").html("");
            jQuery("#ConfirmPwdForResetPwdErr").html("Your password and confirmation password do not match.");
            jQuery("#conpwdForResetPwd").focus();
            return false;
        }
        jQuery("#ConfirmPwdForResetPwdErr").html("");
        return true;
    }

    validateRegExp(expression: string): boolean {
        let count: number = 0;
        if (/^(?=.*[a-z]).+$/.test(expression)) {
            count++;
        }
        if (/^(?=.*[A-Z]).+$/.test(expression)) {
            count++;
        }
        if (/[$-/:-?{-~!"^_`\[\]]/.test(expression)) {
            count++;
        }
        if (/^(?=.*\d).+$/.test(expression)) {
            count++;
        }
        if (count >= 3) {
            return true;
        }
        return false;
    }

    logIn(): boolean {

        if (this.userName == "") {
            jQuery("#EmailErr").html("This information is required.");
            jQuery("#email").focus();
            //check email pattern?
            return false;
        }
        else if (this.passwd == "") {
            jQuery("#PwdErr").html("This information is required.");
            jQuery("#pwd").focus();
            return false;
        }
        else {
            jQuery("#EmailErr").html("");
            jQuery("#PwdErr").html("");
            jQuery("#userErr").html("");
            
            //save user name & password in localStorage
            if(this.rememeberMe){
                localStorage.setItem("everest-client-portal-rememeberMe", JSON.stringify({Name:this.userName,Password:""}));
            }else{
                localStorage.removeItem("everest-client-portal-rememeberMe");
            }

            this.getUser();
            //if (currentUser) {
            //    this._cookieService.putObject("CurrentUser", currentUser)
            //    window.location.reload();
            //}
        }
    };




    constructor(private _cookieService: CookieService, private _loginService: LoginService, private router: Router) {

        // _cookieService.put("test.com", "testCookie");
        // console.log(_cookieService.get('test.com'));

        // console.log(_cookieService.get('SMSESSION'));

        // console.dir(_cookieService.getAll());

        //let cookieName = Cookie.get("imshealth.com");
        //console.log(cookieName);
    }

    getUser(): any {
        this._loginService.getToken(this.userName, this.passwd).then(
            u => {
                if (u.hasOwnProperty('_body')) {
                    var token = JSON.parse(u._body);
                   // console.log('token: ', token.access_token);
                    CommonService.setCookie("token", token.access_token, 1);
                    this.getUserDetail();
                }
                //else if (u.hasOwnProperty('error')) {
                //    var message;
                //    if (u.error.indexOf("error_descriptio") != -1) {
                //        var message = u.error.substring(u.error.lastIndexOf("error_descriptio") + 20, u.error.indexOf("}") - 1);
                //        jQuery("#LoginErr").html(message);
                //        setTimeout(function () {
                //            jQuery("#LoginErr").html("");
                //        }, 5000);
                //    } else {
                //        jQuery("#LoginErr").html("Login failed.");
                //        setTimeout(function () {
                //            jQuery("#LoginErr").html("");
                //        }, 5000);
                //    }
                //}
            });
    }
    getUserDetail(): any {
        //this.currentUser.push(new User(0,0,"","",""));
        this._loginService.getUserInfo(this.userName, this.passwd).then(
            usr => {
                //console.log(usr);
                this.currentUser = usr;
                if (this.currentUser[0]) {
                   // console.log("putuser=", this.currentUser[0]);
                    this._cookieService.putObject('CurrentUser', this.currentUser[0]);
                    if (this.rememeberMe == true) {
                        this._cookieService.put('EmailId', this.currentUser[0].EmailId);
                    }
                    else {
                        this._cookieService.remove('EmailId');
                    }
                    window.location.reload();
                }
                else
                    jQuery("#LoginErr").html("Login failed.");
            })
            .catch(() => { console.log('Login failed.'); jQuery("#LoginErr").html("Login failed.") })
            .then(() => console.log('Login operation completed'));
    }

    GetPassword(): any {
        this.isClickedOnce = false;
        if (this.userName == "") {
            jQuery("#EmailErr").html("This information is required.");
            jQuery("#email").focus();
            return false;
        }
        else {
            jQuery("#EmailErr").html("");
            jQuery("#PwdErr").html("");
            jQuery("#userErr").html("");
            this._loginService.getUserEmail(this.userName)
                .then(email => {
                    if (email[0]) {
                        this.emailAddress = email[0].Email;
                        //alert(this.emailAddress);

                        this.lgModalLogin.config.backdrop = 'static';
                        this.lgModalLogin.config.keyboard = false;
                        this.lgModalLogin.show();
                    }
                    else
                        jQuery("#userErr").html("User inactive or email address invalid.");

                });


        }

    }
    sendPassword() {
        this.isClickedOnce = true;
        this._loginService.sendPassword(this.userName).then(
            () => {

                this.lgModalLogin.hide();
                this.replyModal.show();
                this.isClickedOnce = false;
                // alert('An email has been sent to ' + this.emailAddress + ' successfully.');



            });
    }
    closeDialog() {
        this.replyModal.hide();
    }
    cancelPasswordRetrieve() {
        this.lgModalLogin.hide();
    }
}
