import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:qrisku/bloc/convert_qris/qris_bloc.dart';
import 'package:qrisku/bloc/default_qris/default_qris_bloc.dart';
import 'package:qrisku/ui/screens/form_screen.dart';
import 'package:qrisku/ui/screens/history_screen.dart';
import 'package:qrisku/ui/screens/qris_screen.dart';
import 'package:qrisku/ui/screens/setup_qris_screen.dart';
import 'package:qrisku/ui/widgets/app_config_widget.dart';
import 'package:qrisku/ui/widgets/card_history.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tabIndex = 0;
  final QrisBloc _qrisBloc = Get.find();
  final DefaultQrisBloc _defaultQrisBloc = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _qrisBloc.add(GetAllQris(isFromHome: true));
    _defaultQrisBloc.add(GetDefaultQris());
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: tabIndex == 1
          ? AppBar(
              backgroundColor: Color(0xfff11542).withOpacity(0.8),
              title: const Text('QrisKu'),
            )
          : null,
      backgroundColor: tabIndex == 0 ? Color(0xfff11542) : null,
      body: tabIndex == 0
          ? _body(_size)
          : SetupQrisScreen(bloc: _defaultQrisBloc),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tabIndex,
        onTap: (index) {
          setState(() {
            tabIndex = index;
          });
        },
        selectedItemColor: Color(0xfff11542),
        elevation: 10,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined), label: 'Setting')
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xfff11542),
        child: Icon(Icons.add),
        onPressed: () {
          if (_defaultQrisBloc.state.data == null) {
            showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text('Error'),
                  content: Text('Anda belum setting default QRIS'),
                ).build(context);
              },
            );
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => FormScreen()));
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _body(Size _size) {
    return SafeArea(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(18, 12, 18, 6),
            decoration: const BoxDecoration(
              image: DecorationImage(
                opacity: 0.2,
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'QrisKu',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(
                          Icons.help_outline,
                          color: Color(0xff0f1735),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 14),
                Container(
                  height: 100,
                  padding: EdgeInsets.all(12),
                  width: _size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Color(0xfff11542), width: 2),
                      color: const Color(0xfff11542).withOpacity(0.5)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('QrisKu 100% offline aplikasi konversi QRIS.',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),
                      SizedBox(
                        height: 14,
                      ),
                      InkWell(
                        onTap: () async {
                          // await Share.shareFiles([_file.path]);
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          child: Text(
                            'Ajak teman pakai QrisKu',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          DraggableScrollableSheet(
            minChildSize: 0.75,
            initialChildSize: 0.75,
            builder:
                (BuildContext context, ScrollController scrollController) =>
                    Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
              ),
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 6,
                      child: Divider(
                          thickness: 3, height: 4, color: Colors.grey[300]),
                    ),
                    SizedBox(height: 12),
                    _cardQrisInfo(_size),
                    SizedBox(height: 16),
                    _riwayat()
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _riwayat() {
    return Container(
      padding: const EdgeInsets.only(left: 6, right: 6),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Riwayat Generate QRIS',
                  style: TextStyle(
                      color: Color(0xff0f1735),
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HistoryScreen()));
                  },
                  child: const Icon(Icons.arrow_forward_rounded,
                      color: Color(0xff0f1735)))
            ],
          ),
          const SizedBox(height: 14),
          BlocBuilder(
              bloc: _qrisBloc,
              builder: (context, QrisState state) {
                if (state.isLoading) {
                  return const CircularProgressIndicator();
                } else if (state.isError) {
                  return Text('${state.message}');
                } else {
                  if (state.datas.isEmpty) {
                    return const Text('Tidak ada data');
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.datas.length,
                      itemBuilder: (context, index) {
                        var data = state.datas[index];
                        return CardHistory(
                          dataQr: data.dataQr,
                          title: data.nominal,
                          subTitile: data.title,
                          dateTime:
                              '${data.dateTime.day}-${data.dateTime.month}-${data.dateTime.year} ${data.dateTime.hour}:${data.dateTime.minute}',
                        );
                      });
                }
              }),
        ],
      ),
    );
  }

  Widget _cardQrisInfo(Size _size) {
    return BlocBuilder(
      bloc: _defaultQrisBloc,
      builder: (context, DefaultQrisState state) {
        return Container(
          padding: const EdgeInsets.all(16),
          width: _size.width,
          decoration: BoxDecoration(
              // color: const Color(0xff05796b),
              color: Color(0xfff11542).withOpacity(0.8),
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12),
                        Text('Nama Merchant',
                            style: TextStyle(
                                color: Colors.grey[100],
                                fontWeight: FontWeight.w400)),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                            state.data == null ||
                                    state.data!.merchantName.isEmpty
                                ? 'Tidak ada data'
                                : state.data!.merchantName,
                            maxLines: 2,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (state.data != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    QrisScreen(data: state.data!.defaultCode)));
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 0.9),
                        image: DecorationImage(
                          image: AssetImage("assets/icons/qris_white.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox()
                ],
              ),

              ///
              SizedBox(height: 16),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('NMID',
                              style: TextStyle(
                                  color: Colors.grey[100],
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12)),
                          SizedBox(height: 4),
                          Text(
                              state.data == null || state.data!.nmId.isEmpty
                                  ? 'Tidak ada data'
                                  : state.data!.nmId,
                              maxLines: 1,
                              style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Flexible(
                        flex: 1,
                        child:
                            VerticalDivider(color: Colors.white, thickness: 1)),
                    Flexible(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Dicetak oleh',
                                style: TextStyle(
                                    color: Colors.grey[100],
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12)),
                            SizedBox(height: 4),
                            Text(
                                state.data == null ||
                                        state.data!.pencetak.isEmpty
                                    ? 'Tidak ada data'
                                    : state.data!.pencetak,
                                maxLines: 1,
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ))
                  ],
                ),
              ),
              SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}
