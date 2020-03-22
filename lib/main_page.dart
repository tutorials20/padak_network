import 'dart:convert';

import "package:flutter/material.dart";

import 'grid_page.dart';
import 'list_page.dart';

// 2-1. 메인화면 - 라이브러리 임포트

import 'model/response/movies_response.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  // 2-1. 메인화면 - 서버로부터 받아올 영화 목록 데이터 변수 선언

  int _selectedTabIndex = 0;

  // 2-1. 메인화면 - 선택한 sort 방식에 대한 변수 선언


  // 2-2. 메인화면 - initState() 에서 영화 목록을 가져옵니다.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // 2-4. 메인화면 - title 수정
          title: Text('Movie'),
          leading: Icon(Icons.menu),
          actions: <Widget>[
            // 2-4. 메인화면 - 팝업 메뉴 호출 함수화 (호출)
            PopupMenuButton<int>(
              icon: Icon(Icons.sort),
              onSelected: (value) {
                if (value == 0)
                  print("예매율순");
                else if (value == 1)
                  print("큐레이션");
                else
                  print("최신순");
              },
              itemBuilder: (context) {
                return [
                  PopupMenuItem(value: 0, child: Text("예매율순")),
                  PopupMenuItem(value: 1, child: Text("큐레이션")),
                  PopupMenuItem(value: 2, child: Text("최신순"))
                ];
              },
            )
          ],
        ),
        // 2-2. 메인화면 - _buildPage() 로직 전면 수정
        body: _buildPage(_selectedTabIndex),
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

  // 2-4. 메인화면 - 팝업 메뉴 호출 함수화 (선언)

  // 2-4. 메인화면 - 클릭 시 실행될 로직 작성

  // 2-4. 메인화면 - 각 index 에 맞는 제목을 호출해주는 로직 작성

}

// 2-2. 메인화면 - _buildPage() 함수 내용 수정
Widget _buildPage(index){
  if(index == 0)
    return ListPage();
  else
    return GridPage();
}
