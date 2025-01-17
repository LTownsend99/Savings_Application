import 'package:flutter/material.dart';
import 'package:savings_application/controller/account_controller.dart';
import 'package:savings_application/helpers/date_time_helper.dart';
import 'package:savings_application/helpers/default.dart';

class RegisterPage extends StatelessWidget {
  final newDateController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final childIdController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AccountController accountController = AccountController();

  final List<String> roles = ["parent", "child"];
  String? selectedRole;
  bool _isPasswordVisible = false;
  DateTime? dateOfBirth;

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != dateOfBirth) {
      dateOfBirth = pickedDate;
      (context as Element).markNeedsBuild(); // Update UI
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Default.getPageBackground(),
      appBar: AppBar(
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            children: [
              /// Title
              Text(
                "Let's create an account",
                style: TextStyle(
                    fontSize: 30,
                    color: Default.getTitleColour(),
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              /// Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    /// First and Last Name
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: firstNameController,
                            decoration: const InputDecoration(
                                labelText: "First Name",
                                prefixIcon: Icon(Icons.person)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "First name is required";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: lastNameController,
                            decoration: const InputDecoration(
                                labelText: "Last Name",
                                prefixIcon: Icon(Icons.person)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Last name is required";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    /// Email
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                          labelText: "Email", prefixIcon: Icon(Icons.email)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email is required";
                        } else if (!RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                            .hasMatch(value)) {
                          return "Enter a valid email address";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    /// Password
                    /// Password

                    TextFormField(
                      controller: passwordController,
                      obscureText: !_isPasswordVisible, // Toggle visibility
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.password),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            _isPasswordVisible = !_isPasswordVisible;
                            (context as Element).markNeedsBuild(); // Update UI
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        } else if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    /// Role
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                        labelText: "Role",
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      value: selectedRole,
                      items: roles
                          .map((role) => DropdownMenuItem<String>(
                                value: role,
                                child: Text(role),
                              ))
                          .toList(),
                      onChanged: (value) {
                        selectedRole = value;
                      },
                      validator: (value) {
                        if (value == null) {
                          return "Role is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'Enter child account ID to link a child account (optional)',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 10),

                    /// childId
                    TextFormField(
                      controller: childIdController,
                      decoration: const InputDecoration(
                          labelText: "Child Id",
                          prefixIcon: Icon(Icons.perm_identity)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return null; // Allow empty value, since it's optional
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    /// DOB
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            // Prevent manual input
                            decoration: const InputDecoration(
                              labelText: "Date of Birth",
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            controller: TextEditingController(
                              text: dateOfBirth != null
                                  ? "${dateOfBirth!.year}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}"
                                  : "", // Format date
                            ),
                            onTap: () => _selectDate(context),
                            // Show DatePicker on tap
                            validator: (value) {
                              if (dateOfBirth == null) {
                                return "Date of Birth is required";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    /// Create Account Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {

                            if(dateOfBirth == null)
                              {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Please select a valid date of birth."),
                                    ),
                                );
                                return;
                              }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Creating account..."),
                              ),
                            );

                            bool isAccountCreated =
                                await accountController.createAccount(
                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                              email: emailController.text,
                              passwordHash: passwordController.text,
                              role: selectedRole!,
                              childId: childIdController.text,
                              dateOfBirth: dateOfBirth!,
                            );

                            if (isAccountCreated) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text("Account successfully created!"),
                                ),
                              );
                              Future.delayed(Duration(seconds: 1), () {
                                Navigator.pop(context);
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Account creation failed. Please try again."),
                                ),
                              );
                            }
                          }
                        },
                        color: Default.getTitleColour(),
                        textColor: Colors.white,
                        child: Text(
                          'Create Account',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
