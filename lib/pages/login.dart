import 'package:flutter/material.dart';
import 'package:savings_application/controller/account_controller.dart';
import 'package:savings_application/helpers/default.dart';
import 'package:savings_application/model/accountModel.dart';
import 'package:savings_application/pages/child/child_home.dart';
import 'package:savings_application/pages/parent/parent_home.dart';
import 'package:savings_application/pages/register.dart';
import 'package:savings_application/user/user_account.dart';
import 'package:savings_application/user/user_id.dart';

class LoginPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AccountController accountController = AccountController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Default.getPageBackground(),
      appBar: AppBar(
        title: Text(
          'Login Page',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.green],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Login',
            style: TextStyle(
                fontSize: 30,
                color: Default.getTitleColour(),
                fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Email
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Password
                  TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter Password',
                      prefixIcon: Icon(Icons.password),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Login Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          final email = emailController.text;
                          final password = passwordController.text;

                          // Call the login method instead of getAccount
                          final account = await accountController.login(
                              email: email, password: password);
                          print('Account Data: $account');

                          if (account != null) {
                            AccountModel accountModel = AccountModel.fromJson(account);
                            UserAccount().saveAccount(accountModel);

                            final role = account['role'];
                            if (role == 'child') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChildHomePage()),
                              );
                            } else if (role == 'parent') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ParentHomePage()),
                              );
                            }
                            UserId().userId =
                                account['userId'].toString(); // Store userId globally
                            print(
                                "User ID stored globally: ${UserId().userId}");
                          } else {
                            // Show error message if login failed
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Invalid email or password"),
                              ),
                            );
                          }
                        }
                      },
                      color: Default.getTitleColour(),
                      textColor: Colors.white,
                      child: Text(
                        'Login',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ),

                  // Register Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()),
                        );
                      },
                      color: Default.getTitleColour(),
                      textColor: Colors.white,
                      child: Text(
                        'Register',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
