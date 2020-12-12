import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AuthForm extends StatefulWidget {

  AuthForm(this.submitForm,this.isLoading);

  final bool isLoading;
  final void Function(String email,String userName, String password, bool isLogin,) submitForm;


  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {

  final _formKey = GlobalKey<FormState>();
  var _isLogin = false;
  String _userEmail;
  String _userName;
  String _userPassword;

  void _onSubmit(){
    FocusScope.of(context).unfocus();
    if(_formKey.currentState.validate())
      {
        _formKey.currentState.save();
        widget.submitForm(
          _userEmail,
          _userName,
          _userPassword,
          _isLogin,
        );
      }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
        ),
        margin: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    key: ValueKey("Email address"),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText:'Email address',
                    ),
                    validator: (value)
                    {
                      if(value.isEmpty || !value.contains('@'))
                        {
                          return "Please enter a valid email!";
                        }
                      return null;
                    },
                    onSaved:(value){
                      _userEmail = value;
                    },
                  ),
                  if(_isLogin)
                  TextFormField(
                    key: ValueKey("Username"),
                    decoration: InputDecoration(
                      labelText: "Username",
                    ),
                    validator: (value) {
                      if(value.isEmpty ){
                        return "Username can't be empty!";
                      }
                      return null;
                    },
                    onSaved: (value){
                      _userName = value;
                    },
                  ),
                  TextFormField(
                    key: ValueKey("Password"),
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                    validator: (value){
                      if(value.isEmpty || value.length<6) {
                          return "Password should be at least contain 6 character";
                        }
                      return null;
                    },
                    onSaved: (value)
                    {
                      _userPassword = value;
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if(widget.isLoading)
                    CircularProgressIndicator(),
                  if(!widget.isLoading)
                  RaisedButton(
                      child: Text(_isLogin ? "SignIn":"LogIn"),
                    onPressed: _onSubmit,
                  ),
                  if(!widget.isLoading)
                  FlatButton(
                      child: Text(_isLogin ? "Already have an account ? " : "Create a new account ?"),
                      onPressed: ()
                    {
                      setState(() {
                        _isLogin = !_isLogin;
                        _formKey.currentState.reset();
                      });
                    },)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
