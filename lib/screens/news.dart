import 'package:flutter/material.dart';
import 'package:messaging_app/custom_components.dart';
import 'package:messaging_app/models/model_news.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api.dart';
import '../signin_helper.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  var userImg =
      'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png';
  String? userID;
  List<Article> newsList = [];

  void getUserData() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      userImg = pref.getString(USER_IMG)!;
    });
    getNews();
  }

  void getNews() async {
    List<Article> list = await API().getNewsHeadlines();

    setState(() {
      newsList = list;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Topbar(
          title: 'Hot Tech News',
          action: CircleAvatar(
            radius: 3.h,
            backgroundColor: blackColor,
            backgroundImage: NetworkImage(userImg),
          ),
        ),
        Expanded(
            child: newsList.isNotEmpty
                ? ListView.separated(
                  physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(2.h),
                    itemCount: newsList.length,
                    separatorBuilder: (context, index) => SizedBox(height: 2.h),
                    itemBuilder: (context, index) => CardNews(
                      data: newsList[index],
                      onClick: () async {},
                    ),
                  )
                : Center(
                    child: OutlinedButton(
                        onPressed: () {
                          getNews();
                        },
                        child: MyText('Refresh')),
                  ))
      ],
    );
  }
}

class CardNews extends StatelessWidget {
  const CardNews({super.key, required this.data, required this.onClick});
  final Article data;
  final Function() onClick;

  @override
  Widget build(BuildContext context) {
    return MyCard(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.h),
        child: InkWell(
          onTap: onClick,
          child: Row(
            children: [
              Container(
                width: 12.h,
                height: 12.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1.h),
                    image: DecorationImage(
                        image: NetworkImage(data.urlToImage ??
                            'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png'),
                        fit: BoxFit.cover)),
              ),
              SizedBox(
                width: 2.h,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    data.title,
                    weight: FontWeight.w600,
                    maxLines: 3,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  MyText(
                    'By ${data.author}',
                    color: Colors.grey,
                  )
                ],
              ))
            ],
          ),
        ));
  }
}
