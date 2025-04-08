import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacex_bloc/features/spacex/bloc/spacex_bloc.dart';
import 'package:spacex_bloc/screens/language_screen.dart';

import '../generated/l10n.dart';

class SpacexHome extends StatefulWidget {
  const SpacexHome({super.key});

  @override
  State<SpacexHome> createState() => _SpacexHomeState();
}

class _SpacexHomeState extends State<SpacexHome> {
  @override
  void initState() {
    super.initState();
    // เรียกใช้งานฟังก์ชัน spacexFetchEvent และ spacexSearchEvent
    // context.read<SpacexBloc>().add(
    //   SpacexFetchEvent(),
    // ); // เรียกใช้งานฟังก์ชัน spacexFetchEvent
    context.read<SpacexBloc>().add(SpacexSearchEvent(search: ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        backgroundColor: const Color.fromARGB(255, 74, 23, 139),
        title: Row(
          children: [Text(S.of(context).app_title), const Icon(Icons.rocket)],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: 232,
              height: 40,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: const Icon(Icons.search),
                  ),
                  Flexible(
                    child: Center(
                      child: TextField(
                        onChanged: (value) {
                          // ใช้ onChanged ในการค้นหาข้อมูล โดยส่งค่าที่พิมพ์เข้าไปใน Bloc
                          print('Search Value: $value');
                          context.read<SpacexBloc>().add(
                            SpacexSearchEvent(search: value),
                          );
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: S.of(context).search_hint,
                          contentPadding: EdgeInsets.all(10.0),
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LanguageScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.language),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 9.0),
        child: BlocConsumer<SpacexBloc, SpacexState>(
          // ใช้ BlocConsumer ในการรับข้อมูลจาก Bloc
          listener: (context, state) {
            // ใช้ listener ในการรับข้อมูลจาก Bloc
            // if (state is SpacexFetchingSuccessfulState) {
            //   print(state.spacexLists);
            // }
          },
          builder: (context, state) {
            if (state is SpacexFetchingLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              ); // กำลังโหลด
            } else if (state is SpacexFetchingSuccessfulState) {
              final successState = state;
              return ListView.builder(
                itemCount: successState.spacexLists.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5, // เพิ่มเงาเพื่อให้กรอบดูมีมิติ
                    margin: const EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 8.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        22.0,
                      ), // ปรับมุมให้โค้ง
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          successState.spacexLists[index].smallimage,
                          width: 50, // กำหนดขนาดรูป
                          height: 50,
                          fit: BoxFit.cover, // ปรับให้ภาพพอดีกับกรอบ
                          errorBuilder: // กำหนดรูปภาพเมื่อเกิดข้อผิดพลาด
                              (context, error, stackTrace) => const Icon(
                                Icons.image_not_supported_rounded,
                                size: 50,
                                color: Colors.grey,
                              ),
                        ),
                      ),
                      title: Text(
                        successState.spacexLists[index].name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(successState.spacexLists[index].dateUtc),
                          Text(
                            successState.spacexLists[index].success
                                ? S.of(context).launch_success
                                : S.of(context).launch_failure,
                            style: TextStyle(
                              color:
                                  successState.spacexLists[index].success
                                      ? Colors.green
                                      : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      // subtitle: Text(successState.spacexLists[index].details),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                successState.spacexLists[index].name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(
                                      successState
                                          .spacexLists[index]
                                          .largeimage,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                                Icons.broken_image,
                                                size: 100,
                                              ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      S
                                          .of(context)
                                          .details(
                                            successState
                                                .spacexLists[index]
                                                .details,
                                          ),
                                    ),
                                    Text(
                                      S
                                          .of(context)
                                          .rocket(
                                            successState
                                                .spacexLists[index]
                                                .rocket,
                                          ),
                                    ),
                                    Text(
                                      S
                                          .of(context)
                                          .launchpad(
                                            successState
                                                .spacexLists[index]
                                                .launchpad,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(S.of(context).close),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text(S.of(context).error_no_data));
            }
          },
        ),
      ),
    );
  }
}
