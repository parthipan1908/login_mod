import 'package:flutter/material.dart';
import 'package:login_mod/password_check_data.dart';

class DashboardPage extends StatefulWidget {
  final PasswordDetails details;
  DashboardPage({Key key, @required this.details}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    final List<UserAddress> _userAddress =
        widget?.details?.userAddress != null ? widget.details.userAddress : [];
    return Scaffold(
      appBar: AppBar(
        title: widget?.details?.userAddress != null
            ? Text(widget.details.firstName + widget.details.lastName)
            : Text('data'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: _userAddress == null
          ? Container(
              child: Center(child: Text('Welcome to Broz')),
            )
          : ListView.builder(
              itemCount: _userAddress.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 50,
                  padding: EdgeInsets.all(10),
                  child: Text(_userAddress[index].address),
                );
              }),
    );
  }
}
