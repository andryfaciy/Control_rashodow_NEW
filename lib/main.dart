import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_hive_example/screens/add_todo/add_transaction.dart';
import 'models/todo.dart';
import 'client/hive_names.dart';

void main() async {
  //Начало программы
  //   hive initialization

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() async {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'История транзакций'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: new Drawer(
        //Боковая выползающая менюшка
        child: new ListView(
          children: <Widget>[
            new AppBar(
              title: new Text('Меню'),
            ),
            ButtonTheme(
              height: 60,
              child: RaisedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TemplatesPage()));
                },
                child: Text('Шаблоны', style: TextStyle(fontSize: 15)),
                color: Colors.white,
              ),
            ),
            ButtonTheme(
              height: 60,
              child: RaisedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingsPage()));
                },
                child: Text('Настройки', style: TextStyle(fontSize: 15)),
                color: Colors.white,
              ),
            ),
            ButtonTheme(
                height: 60,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => WalletsPage()));
                  },
                  child: Text('Кошельки', style: TextStyle(fontSize: 15)),
                  color: Colors.white,
                ))
          ],
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Todo>(HiveBoxes.todo).listenable(),
        builder: (context, Box<Todo> box, _) {
          if (box.values.isEmpty)
            return Center(
              child: Text("Лист транзакций пуст"),
            );
          return ListView.builder(
            //Список
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              Todo res = box.getAt(index);
              return Dismissible(
                background: Container(color: Colors.red),
                key: UniqueKey(),
                onDismissed: (direction) {
                  res.delete();
                },
                child: ListTile(
                    //title: Text("$res.Summa"),
                    subtitle: Text(res.Cat +
                        '                                                                       ' +
                        res.Data +
                        ' ₽'),
                    leading: res.complete
                        ? Icon(Icons.check_box)
                        : Icon(Icons.check_box_outline_blank),
                    onTap: () {
                      res.complete = !res.complete;
                      res.save();
                    }),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        //Плавающая кнопка в нижнем правом углу
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AddTodo())),
        tooltip: 'Add transaction',
        child: Icon(Icons.add),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _TabsPageState();
}

class _TabsPageState extends State<SettingsPage> {
  bool lights;
  bool isInstructionView;
  bool selected = false;
  @override
  void initState() {
    isInstructionView = Global.shared.isInstructionView;
    lights = Global.shared.lights;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Экран настроек
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Настройки"),
      ),
      body: Column(children: [
        new Container(
          alignment: FractionalOffset(0.95, 0.02),
          child: SwitchListTile(
            title: Text("Тёмная тема", style: TextStyle(fontSize: 16)),
            value: isInstructionView,
            onChanged: (bool isOn) {
              print(isOn);
              setState(() {
                isInstructionView = isOn;
                Global.shared.isInstructionView = isOn;
                isOn = !isOn;
                print(isInstructionView);
              });
            },
            activeColor: Colors.green,
            inactiveTrackColor: Colors.red,
            inactiveThumbColor: Colors.red,
          ),
        ),
        new Container(
          alignment: FractionalOffset(0.95, 0.02),
          decoration: BoxDecoration(
              border: Border.all(
            width: 0.05,
          )),
          child: SwitchListTile(
            title: Text("Уведомления", style: TextStyle(fontSize: 16)),
            value: lights,
            onChanged: (bool isOn) {
              print(isOn);
              setState(() {
                lights = isOn;
                Global.shared.lights = isOn;
                isOn = !isOn;
                print(lights);
              });
            },
            activeColor: Colors.green,
            inactiveTrackColor: Colors.red,
            inactiveThumbColor: Colors.red,
          ),
        ),
        GestureDetector(
          onTap: () {
            print("Tapped a Container");
          },
          child: Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                border: Border.all(
              width: 0.05,
            )),
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 35,
                    child: Text("Язык", style: TextStyle(fontSize: 16)),
                  ),
                  Container(
                    height: 14,
                    child: Text("Русский",
                        style: TextStyle(fontSize: 12, color: Colors.blue),
                        textAlign: TextAlign.left),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          //Для чего он хуй его знает но пусть будет
          onTap: () {
            print("Tapped a Container");
          },
          child: Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                border: Border.all(
              width: 0.05,
            )),
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 35,
                    child: Text("Выбранная валюта",
                        style: TextStyle(fontSize: 16)),
                  ),
                  Container(
                    height: 14,
                    child: Text("Российский рубль",
                        style: TextStyle(fontSize: 12, color: Colors.blue),
                        textAlign: TextAlign.left),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          //О5 этот парень
          onTap: () {
            print("Tapped a Container");
          },
          child: Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                border: Border.all(
              width: 0.05,
            )),
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 20, 0, 0),
              child: Column(
                children: [
                  Text("Резервная копия", style: TextStyle(fontSize: 16))
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            print("Tapped a Container");
          },
          child: Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                border: Border.all(
              width: 0.05,
            )),
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 20, 0, 0),
              child: Column(
                children: [
                  Text("Обратная связь", style: TextStyle(fontSize: 16))
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class Global {
  static final shared = Global();
  bool isInstructionView = false;
  bool lights = false;
}

class TemplatesPage extends StatelessWidget {
  //Экран Шаблоны
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Шаблоны'),
        ),
        body: ListView(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                print("Tapped a Container");
              },
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    border: Border.all(
                  width: 0.05,
                )),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        //Вот эту всю хуету надо удалить и сделать как на главном экране
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: EdgeInsets.fromLTRB(15, 0, 0, 10),
                                child: Text("Расход",
                                    style: TextStyle(fontSize: 16))),
                            Container(
                              padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
                              child: Text("Коммунальные услуги",
                                  style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                      Text("-23345",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                print("Tapped a Container");
              },
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    border: Border.all(
                  width: 0.05,
                )),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: EdgeInsets.fromLTRB(15, 0, 0, 10),
                                child: Text("Доход",
                                    style: TextStyle(fontSize: 16))),
                            Container(
                              padding: EdgeInsets.fromLTRB(15, 5, 0,
                                  5), //И вот это тоже ибо это все визуал
                              child: Text("Зарплата",
                                  style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                      Text("+28345",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                print("Tapped a Container");
              },
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    border: Border.all(
                  width: 0.05,
                )),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: EdgeInsets.fromLTRB(15, 0, 0, 10),
                                child: Text("Расход",
                                    style: TextStyle(fontSize: 16))),
                            Container(
                              padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
                              child:
                                  Text("Т.О.", style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                      Text("-32345",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                print("Tapped a Container");
              },
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    border: Border.all(
                  width: 0.05,
                )),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: EdgeInsets.fromLTRB(15, 0, 0, 10),
                                child: Text("Доход",
                                    style: TextStyle(fontSize: 16))),
                            Container(
                              padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
                              child: Text("Стипендия",
                                  style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                      Text("+2500",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                print("Tapped a Container");
              },
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    border: Border.all(
                  width: 0.05,
                )),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: EdgeInsets.fromLTRB(15, 0, 0, 10),
                                child: Text("Расход",
                                    style: TextStyle(fontSize: 16))),
                            Container(
                              padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
                              child:
                                  Text("Досуг", style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                      Text("-650023",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Increment',
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Newshablone()));
          },
        ));
  }
}

class WalletsPage extends StatelessWidget {
  //Экран кошельков тоже самое и что и с шаблонами надо делать пункты как на главном экране
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Кошельки'),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        body: Column(
          children: [
            GestureDetector(
              onTap: () {
                print("Tapped a Container");
              },
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    border: Border.all(
                  width: 0.05,
                )),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                        width: 200,
                        child:
                            Text("Кошелек 1", style: TextStyle(fontSize: 16)),
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(100, 5, 0, 0),
                          child: Text("65023 Р",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                print("Tapped a Container");
              },
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    border: Border.all(
                  width: 0.05,
                )),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                        width: 200,
                        child:
                            Text("Кошелек 2", style: TextStyle(fontSize: 16)),
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(100, 5, 0, 0),
                          child: Text("6523 Р",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                print("Tapped a Container");
              },
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    border: Border.all(
                  width: 0.05,
                )),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                        width: 200,
                        child:
                            Text("Кошелек 3", style: TextStyle(fontSize: 16)),
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(100, 5, 0, 0),
                          child: Text("50232 Р",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Increment',
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Newswallet()));
          },
        ));
  }
}

//Отчеты я на хуй удалил ибо это юзлес тема

class Newshablone extends StatelessWidget {
  //Экран создания новыго шаблона
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Создание нового шаблона'),
        ),
        body: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: Colors.blue[600],
                  padding: EdgeInsets.fromLTRB(40, 40, 0, 0),
                  height: 100,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Text("Расход",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 2,
                  padding: EdgeInsets.fromLTRB(100, 40, 0, 0),
                  child: Text("Доход",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                print("Tapped a Container");
              },
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    border: Border.all(
                  width: 0.05,
                )),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 20, 0, 0),
                  child: Column(
                    children: [
                      Text("Название", style: TextStyle(fontSize: 16))
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                print("Tapped a Container");
              },
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    border: Border.all(
                  width: 0.05,
                )),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 20, 0, 0),
                  child: Column(
                    children: [Text("Сумма", style: TextStyle(fontSize: 16))],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                print("Tapped a Container");
              },
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    border: Border.all(
                  width: 0.05,
                )),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 20, 0, 0),
                  child: Column(
                    children: [
                      Text("Комментарий", style: TextStyle(fontSize: 16))
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                print("Tapped a Container");
              },
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    border: Border.all(
                  width: 0.05,
                )),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 35,
                        child: Text("Кошелек", style: TextStyle(fontSize: 16)),
                      ),
                      Container(
                        height: 14,
                        child: Text("Кошелек 1",
                            style: TextStyle(fontSize: 12, color: Colors.blue),
                            textAlign: TextAlign.left),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                print("Tapped a Container");
              },
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    border: Border.all(
                  width: 0.05,
                )),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 35,
                        child: Text("Период списания",
                            style: TextStyle(fontSize: 16)),
                      ),
                      Container(
                        height: 14,
                        child: Text("1 месяц",
                            style: TextStyle(fontSize: 12, color: Colors.blue),
                            textAlign: TextAlign.left),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Increment',
          child: Icon(Icons.add),
          onPressed: () {},
        ));
  }
}

class Newswallet extends StatelessWidget {
  //Экран создания новыго шаблона
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Создание нового кошелька'),
        ),
        body: ListView(
          children: [
            GestureDetector(
              onTap: () {
                print("Tapped a Container");
              },
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    border: Border.all(
                  width: 0.05,
                )),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 20, 0, 0),
                  child: Column(
                    children: [
                      Text("Название", style: TextStyle(fontSize: 16))
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                print("Tapped a Container");
              },
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    border: Border.all(
                  width: 0.05,
                )),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 20, 0, 0),
                  child: Column(
                    children: [Text("Баланс", style: TextStyle(fontSize: 16))],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                print("Tapped a Container");
              },
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    border: Border.all(
                  width: 0.05,
                )),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 20, 0, 0),
                  child: Column(
                    children: [
                      Text("Иконка",
                          style: TextStyle(
                              fontSize:
                                  16)) //Надо добавить функционала всей этой части кода
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                print("Tapped a Container");
              },
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    border: Border.all(
                  width: 0.05,
                )),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 20, 0, 0),
                  child: Column(
                    children: [Text("Цвет", style: TextStyle(fontSize: 16))],
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Increment',
          child: Icon(Icons.add),
          onPressed: () {},
        ));
  }
}
