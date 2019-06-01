import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:rest_test/db/my_database.dart';
import 'package:rest_test/db/my_photo.dart';
import 'package:rest_test/my_custom_widgets/my_photo_thumbnial.dart';
import 'package:rest_test/my_custom_widgets/my_text.dart';
import 'package:rest_test/pages/view_selected_photo.dart';
import 'package:side_header_list_view/side_header_list_view.dart';
import 'package:rest_test/my_custom_widgets/user_list_tile.dart';
import 'package:rest_test/pages/view_user_data.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomePageStf();
  }
}

class HomePageStf extends StatefulWidget {
  @override
  _HomePageStfState createState() => _HomePageStfState();
}

class _HomePageStfState extends State<HomePageStf> {
  GlobalKey _key = GlobalKey();
  PageController _controller = PageController();
  List listOfUsers;
  List<MyPhoto> listOfPhotos;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomBar(),
      body: _buildPageView(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('Home Page'),
      centerTitle: true,
    );
  }

  FancyBottomNavigation _buildBottomBar() {
    return FancyBottomNavigation(
      key: _key,
      tabs: [
        TabData(iconData: Icons.account_circle, title: "Users"),
        TabData(iconData: Icons.photo_library, title: "Photos"),
      ],
      onTabChangedListener: (position) {
        setState(() {
          _controller.animateToPage(
            position,
            duration: Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
          );
        });
      },
    );
  }

  PageView _buildPageView() {
    return PageView(
      controller: _controller,
      onPageChanged: (int page) {
        setState(() {
          FancyBottomNavigationState fs = _key.currentState;
          fs.setPage(page);
        });
      },
      children: <Widget>[
        _buildUsersPage(),
        _buildAlbumsPage(),
      ],
    );
  }

  Widget _buildUsersPage() {
    if (listOfUsers != null) {
      return _buildListOfUsers(listOfUsers);
    }

    return FutureBuilder(
      future: MyDatabase.getListOfUsers(),
      builder: (context, data) {
        if (data.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        listOfUsers = data.data;
        return _buildListOfUsers(data.data);
      },
    );
  }

  ListView _buildListOfUsers(List users) {
    return ListView.builder(
        itemCount: users.length * 2,
        padding: EdgeInsets.all(4.0),
        itemBuilder: (context, index) {
          if (index % 2 == 1) return SizedBox(height: 8);
          String name = users[index ~/ 2]['name'];
          String email = users[index ~/ 2]['email'];
          int id = users[index ~/ 2]['id'];
          return UserListTile(
            name: name,
            email: email,
            id: id,
            onTap: () => _userClicked(id, name, email),
          );
        });
  }

  void _userClicked(int id, String name, String email) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewUserData(
              id: id,
              email: email,
              name: name,
            ),
      ),
    );
  }

  Widget _buildAlbumsPage() {
    if (listOfPhotos != null) return _buildPhotosList();

    return FutureBuilder(
      future: MyDatabase.getPhotos(),
      builder: (context, data) {
        if (data.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        listOfPhotos = data.data;
        return _buildPhotosList();
      },
    );
  }

  Widget _buildPhotosList() {
    return SideHeaderListView(
      itemCount: listOfPhotos.length,
      padding: EdgeInsets.all(8.0),
      itemExtend: 180.0,
      headerBuilder: (BuildContext context, int index) {
        return SizedBox(
          width: 135.0,
          child: MyText(
            content: 'Album #${listOfPhotos[index].albumId}',
            size: 18,
            isBold: true,
          ),
        );
      },
      itemBuilder: (BuildContext context, int index) {
        MyPhoto photo = listOfPhotos[index];
        return MyPhotoThumbnail(
          url: photo.url,
          thumbnailUrl: photo.thumbnail,
          title: photo.title,
          function: _imageClicked,
        );
      },
      hasSameHeader: (int a, int b) {
        return listOfPhotos[a].albumId == listOfPhotos[b].albumId;
      },
    );
  }

  void _imageClicked(String url, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewPhoto(
              title: title,
              url: url,
            ),
      ),
    );
  }
}
