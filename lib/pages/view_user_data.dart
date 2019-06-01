import 'package:flutter/material.dart';
import 'package:rest_test/db/my_database.dart';
import 'package:rest_test/my_custom_widgets/my_text.dart';
import 'package:expandable/expandable.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewUserData extends StatelessWidget {
  final String name, email;
  final int id;

  ViewUserData({
    this.email,
    this.name,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    return ViewUserDataStf(
      email: email,
      name: name,
      id: id,
    );
  }
}

class ViewUserDataStf extends StatefulWidget {
  final String name, email;
  final int id;

  ViewUserDataStf({
    this.email,
    this.name,
    this.id,
  });
  @override
  _ViewUserDataStateStf createState() => _ViewUserDataStateStf();
}

class _ViewUserDataStateStf extends State<ViewUserDataStf> {
  List<Widget> widgets = [];
  bool dataRecived = false;

  @override
  Widget build(BuildContext context) {
    if (widgets.length == 0) {
      widgets.insert(
        0,
        Stack(children: <Widget>[
          _buildBackground(),
          _buildUserImage(context),
        ]),
      );
      _getUserData();
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.name),
        elevation: 0,
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      )),
    );
  }

  Widget _buildBackground() {
    return Container(
      width: double.infinity,
      height: 135,
      color: Colors.blue,
    );
  }

  Widget _buildUserImage(context) {
    double raduis = 50;
    return Positioned(
      top: 8,
      left: MediaQuery.of(context).size.width / 2 -
          raduis, // to center the avatar image
      child: Hero(
        tag: '${widget.id}',
        child: CircleAvatar(
          radius: raduis,
          child: _getAvatarText(),
          backgroundColor: Colors.amber,
        ),
      ),
    );
  }

  Text _getAvatarText() {
    int spaceIndex = widget.name.indexOf(' ');
    String shortcut = widget.name[0] + widget.name[spaceIndex + 1];
    return Text(
      shortcut,
      style: TextStyle(
        fontSize: 28,
        color: Colors.white,
      ),
    );
  }

  void _getUserData() async {
    setState(() => widgets.add(LinearProgressIndicator()));
    // getting data
    Map<String, dynamic> user = await MyDatabase.getUserById(widget.id);
    // now we have the data
    setState(() {
      widgets.removeLast(); // remove the indicator
      _showUserData(user);
    });
  }

  void _showUserData(Map<String, dynamic> user) {
    widgets.add(SizedBox(height: 8));

    widgets.add(
      _buildPersonalInfo(
        user['username'],
        user['website'],
        user['phone'],
      ),
    );
    widgets.add(SizedBox(height: 8));

    widgets.add(
      _buildAddressInfo(
        user['address-street'],
        user['address-suite'],
        user['address-city'],
        user['address-zipcode'],
        user['address-geo-lat'],
        user['address-geo-lng'],
      ),
    );

    widgets.add(SizedBox(height: 8));

    widgets.add(
      _buildCompanyInfo(
        user['company-name'],
        user['company-catchPhrase'],
        user['company-bs'],
      ),
    );
  }

  ExpandablePanel _buildPersonalInfo(
    String username,
    String website,
    String number,
  ) {
    return ExpandablePanel(
      header: _buildExpandedHeader(Icons.info, 'Personal info'),
      tapHeaderToExpand: true,
      hasIcon: true,
      initialExpanded: true,
      expanded: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildExpandedChild(
            Icons.credit_card,
            'ID: ${widget.id}',
            null,
            null,
            null,
          ),
          _buildExpandedChild(
            Icons.person_pin,
            'Name: ${widget.name}',
            null,
            null,
            null,
          ),
          _buildExpandedChild(
            Icons.person_outline,
            'Username: $username',
            null,
            null,
            null,
          ),
          _buildExpandedChild(
            Icons.mail,
            'Email: ${widget.email}',
            Icons.alternate_email,
            _sendEmail,
            widget.email,
          ),
          _buildExpandedChild(
            Icons.language,
            'website: $website',
            Icons.launch,
            _visitWebsite,
            website,
          ),
          _buildExpandedChild(
            Icons.call,
            'Phone: $number',
            Icons.call,
            _callNumber,
            number,
          ),
        ],
      ),
    );
  }

  void _visitWebsite(String website) async {
    var url = 'http:$website';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('cant launch');
    }
  }

  void _callNumber(String number) async {
    var url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('cant launch');
    }
  }

  void _sendEmail(String email) async {
    var url = 'mailto:$email';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('cant launch');
    }
  }

  ExpandablePanel _buildAddressInfo(
    String street,
    String suite,
    String city,
    String zipcode,
    String geoLat,
    String geoLng,
  ) {
    return ExpandablePanel(
      header: _buildExpandedHeader(Icons.map, 'Address'),
      tapHeaderToExpand: true,
      hasIcon: true,
      expanded: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildExpandedChild(
            Icons.directions_walk,
            'Street: $street',
            null,
            null,
            null,
          ),
          _buildExpandedChild(
            Icons.home,
            'Suite: $suite',
            null,
            null,
            null,
          ),
          _buildExpandedChild(
            Icons.location_city,
            'City: $city',
            null,
            null,
            null,
          ),
          _buildExpandedChild(
            Icons.location_searching,
            'Zipcode: $zipcode',
            null,
            null,
            null,
          ),
          _buildExpandedChild(
            Icons.location_on,
            'Geo-location: \ngeo lat: $geoLat\ngeo lng: $geoLng',
            null,
            null,
            null,
          ),
        ],
      ),
    );
  }

  ExpandablePanel _buildCompanyInfo(
    String companyName,
    String catchPhrase,
    String bs,
  ) {
    return ExpandablePanel(
      header: _buildExpandedHeader(Icons.work, 'Company'),
      tapHeaderToExpand: true,
      hasIcon: true,
      expanded: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildExpandedChild(
            Icons.work,
            'Company: $companyName',
            null,
            null,
            null,
          ),
          _buildExpandedChild(
            Icons.next_week,
            'Catch phrase: $catchPhrase',
            null,
            null,
            null,
          ),
          _buildExpandedChild(
            Icons.event_note,
            'bs: $bs',
            null,
            null,
            null,
          ),
        ],
      ),
    );
  }

  ListTile _buildExpandedChild(IconData leading, String content,
      IconData trailing, Function fun, String toSend) {
    return ListTile(
      leading: Icon(leading),
      title: MyText(content: content),
      trailing: trailing == null
          ? null
          : IconButton(
              icon: Icon(trailing, color: Colors.lightBlue),
              onPressed: () => fun(toSend),
            ),
    );
  }

  Row _buildExpandedHeader(IconData icon, String title) {
    return Row(
      children: <Widget>[
        Icon(
          icon,
          size: 35,
          color: Colors.blue,
        ),
        SizedBox(width: 10),
        MyText(
          content: title,
          isBold: true,
          size: 20,
        )
      ],
    );
  }
}
