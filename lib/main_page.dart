import 'dart:convert';

import "package:flutter/material.dart";

import 'grid_page.dart';
import 'list_page.dart';

// 2-1. 메인화면 - 라이브러리 임포트
import 'package:http/http.dart' as http;

import 'model/response/movies_response.dart';
import 'model/response/movies_response.dart';
import 'model/response/movies_response.dart';
import 'model/response/movies_response.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  // 2-1. 메인화면 - 서버로부터 받아올 영화 목록 데이터 변수 선언
  MoviesResponse _moviesResponse;

  int _selectedTabIndex = 0;

  // 2-1. 메인화면 - 선택한 sort 방식에 대한 변수 선언
  int _sortIndex = 0;

  // 2-2. 메인화면 - initState() 에서 영화 목록을 가져옵니다.
  @override
  void initState() {
    super.initState();
    _requestMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // 2-4. 메인화면 - title 수정
          title: Text(_getMenuTitle(_sortIndex)),
          leading: Icon(Icons.menu),
          actions: <Widget>[
            // 2-4. 메인화면 - 팝업 메뉴 호출 함수화 (호출)
            _buildPopupMenuButton()
          ],
        ),
        // 2-2. 메인화면 - _buildPage() 로직 전면 수정
        body: _buildPage(_selectedTabIndex, _moviesResponse),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.view_list),
              title: Text('List'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_on),
              title: Text('Grid'),
            ),
          ],
          currentIndex: _selectedTabIndex,
          onTap: (index) {
            setState(() {
              _selectedTabIndex = index;
              print("$_selectedTabIndex Tab Clicked");
            });
          },
        ));
  }

  // 2-1. 메인화면 - MovieResponse 데이터 받아오기
  _requestMovies() async {
    setState(() {
      _moviesResponse = null;
    });

    var url = 'http://padakpadak.run.goorm.io/movies?order_types=$_sortIndex';
    print('url: $url');
    final response = await http
        .get(url);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final movies = MoviesResponse.fromJson(jsonData);
      setState(() {
        _moviesResponse = movies;
        print(_moviesResponse.movies.first.title);
      });
    }
  }

  // 2-4. 메인화면 - 팝업 메뉴 호출 함수화 (선언)
  _buildPopupMenuButton() =>
      PopupMenuButton<int>(
        icon: Icon(Icons.sort),
        onSelected: _onTabSortMethod,
        itemBuilder: (context) {
          return [
            PopupMenuItem(value: 0, child: Text(_getMenuTitle(0))),
            PopupMenuItem(value: 1, child: Text(_getMenuTitle(1))),
            PopupMenuItem(value: 2, child: Text(_getMenuTitle(2)))
          ];
        },
      );

// 2-4. 메인화면 - 클릭 시 실행될 로직 작성
  _onTabSortMethod(int index) {
    setState(() {
      _sortIndex = index;
    });
    _requestMovies();
  }

// 2-4. 메인화면 - 각 index 에 맞는 제목을 호출해주는 로직 작성
  _getMenuTitle(int index) => ['예매율', '큐레이션', '최신순'][index];

// 2-2. 메인화면 - _buildPage() 함수 내용 수정
    _buildPage(index, MoviesResponse moviesResponse) {
      if (moviesResponse == null) {
        return Center(child: CircularProgressIndicator());
      }
      switch (index) {
        case 0:
          return ListPage(moviesResponse.movies);
        case 1:
          return GridPage(moviesResponse.movies);
        default:
          return Container();
      }
    }
  }
