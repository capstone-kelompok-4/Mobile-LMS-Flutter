import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../constants/styles.dart';
import '../../data/model/course_detail/course_detail_model.dart';
import '../../widgets/custom_item_section.dart';

class LearningCourseUI extends StatefulWidget {
  final CourseDetailData course;
  const LearningCourseUI({Key? key, required this.course}) : super(key: key);

  @override
  State<LearningCourseUI> createState() => _LearningCourseUIState();
}

class _LearningCourseUIState extends State<LearningCourseUI> {
  List<CourseDetailDataSection> _sections = [];

  @override
  void initState() {
    _sections = widget.course.sections;
    _sections.sort((a, b) => a.number.compareTo(b.number));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 26.0),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.course.name,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: colorTextBlue,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              LinearPercentIndicator(
                padding: EdgeInsets.zero,
                lineHeight: 8.0,
                progressColor: colorOrange,
                backgroundColor: colorBlueDark.withOpacity(.42),
                barRadius: const Radius.circular(10),
                percent: 40 / 100,
              ),
              const SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "avg score: 0.0/5.0",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: colorTextBlue,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    "40%",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: colorTextBlue,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: colorOrange,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
                  child: Text(
                    "Lanjut Belajar",
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 26.0),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Course List",
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      color: colorTextBlue,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 8.0,
                  );
                },
                itemCount: _sections.length,
                itemBuilder: (context, index) {
                  final section = _sections[index];
                  return CustomItemSection(
                    section: section,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
