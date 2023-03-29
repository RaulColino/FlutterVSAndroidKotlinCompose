import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:select_form_field/select_form_field.dart';

import 'package:memshelf/src/Domain/entities/auth_user.dart';
import 'package:memshelf/src/Domain/entities/note.dart';
import 'package:memshelf/src/Domain/entities/storage_user.dart';
import 'package:memshelf/src/Presentation/blocs/app_bloc.dart';
import 'package:memshelf/src/Presentation/blocs/storage_user_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: HomeScreen());

  @override
  Widget build(BuildContext context) {
    void _showcontent() {
      showDialog(
        context: context,
        barrierDismissible: false, // user must tap a button
        builder: (BuildContext context) {
          return const AlertDialog(
            content: CreateNoteForm(),
          );
        },
      );
    }

    final textTheme = Theme.of(context).textTheme;
    final authUser = context.select((AppBloc bloc) => bloc.state.user);
    final userData =
        context.read<StorageUserCubit>().getUserData(authUser); //get data

    return Scaffold(
      appBar: AppBar(
        //title: const Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => context.read<AppBloc>().add(AppLogoutRequested()),
          )
        ],
      ),
      body: HomeBody(authUser: authUser),
      floatingActionButton: FloatingActionButton(
        onPressed: _showcontent,
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  final AuthUser authUser;
  const HomeBody({
    Key? key,
    required this.authUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StorageUserCubit, StorageUserState>(
      builder: (_, state) {
        if (state is StorageUserLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is StorageUserErrorState) {
          return Center(
            child: Text(state.appErr.message),
          );

          // return CreateNameSection(
          //   authUser: authUser,
          //   user: StorageUser(id: authUser.id, name: "", notes: const []),
          // );

        } else if (state is StorageUserReadyState) {
          return NotesView(state.user);
        } else {
          return const Center(child: Text("invalid state"));
        }
      },
    );
  }
}

class CreateNoteForm extends StatefulWidget {
  const CreateNoteForm({
    Key? key,
    this.isSaving = false,
  }) : super(key: key);

  final bool isSaving;

  @override
  State<CreateNoteForm> createState() => _CreateNoteFormState();
}

class _CreateNoteFormState extends State<CreateNoteForm> {
  final _categoryController = TextEditingController();
  final _colorController = TextEditingController();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void initState() {
    //_categoryController.text = widget.user?.name ?? "";
    super.initState();
  }

  final List<Map<String, dynamic>> _colors = [
    {
      'value': '0xFFF44336',
      'label': 'red',
      'textStyle': const TextStyle(color: const Color(0xFFF44336)),
    },
    {
      'value': '0xFF3659F4',
      'label': 'blue',
      'textStyle': const TextStyle(color: const Color(0xFF3659F4)),
    },
    {
      'value': '0xFF82F436',
      'label': 'green',
      'textStyle': const TextStyle(color: const Color(0xFF82F436)),
    },
  ];

  final List<Map<String, dynamic>> _categories = [
    {
      'value': '1',
      'label': 'work',
      'icon': const Icon(Icons.cases),
    },
    {
      'value': '2',
      'label': 'inspiration',
      'icon': const Icon(Icons.cloud),
    },
    {
      'value': '3',
      'label': 'shopping',
      'icon': const Icon(Icons.shopping_cart),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Create note",
              style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SelectFormField(
                type: SelectFormFieldType.dropdown, // or can be dialog
                initialValue: '1',
                icon: const Icon(Icons.category),
                labelText: 'Category',
                items: _categories,
                onChanged: (val) => _categoryController.text = val,
                onSaved: (val) => print("saved category value"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SelectFormField(
                type: SelectFormFieldType.dropdown, // or can be dialog
                initialValue: '0xFFF44336',
                icon: const Icon(Icons.palette),
                labelText: 'Color',
                items: _colors,
                onChanged: (val) {
                  _colorController.text = val;
                  print("color value assigned: " + _colorController.text);
                },
                onSaved: (val) => print("saved color value"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TextField(
                controller: _bodyController,
                decoration: const InputDecoration(labelText: 'Body'),
              ),
            ),
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                    ),
                    child: const Text("CANCEL")),
                ElevatedButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white,
                      elevation: 2,
                      backgroundColor: Colors.black),
                  child: const Text("SAVE"),
                  onPressed: widget.isSaving
                      ? null
                      : () {
                          AuthUser authUser =
                              context.read<AppBloc>().state.user;
                          StorageUser storageUser =
                              context.read<StorageUserCubit>().state.user;
                          Note newNote = Note(
                            category: (_categoryController.text == "")
                                ? "1"
                                : _categoryController.text,
                            color: (_colorController.text == "")
                                ? "0xFFF44336"
                                : _colorController.text,
                            title: _titleController.text,
                            body: _bodyController.text,
                          );
                          List<Note> updatedNotes = [
                            ...storageUser.notes,
                            newNote
                          ];
                          context.read<StorageUserCubit>().saveUserData(
                                authUser,
                                authUser.id,
                                storageUser.name,
                                updatedNotes,
                              );
                          Navigator.of(context).pop();
                        },
                ),
                if (widget.isSaving) const CircularProgressIndicator(),
                // ElevatedButton(
                //   child: Text("ADD NOTE"),
                //   onPressed: () {
                //     context.read<StorageUserCubit>().saveUserData(
                //       context.read<AppBloc>().state.user,
                //       context.read<AppBloc>().state.user.id,
                //       _nameController.text,
                //       [],
                //     );
                //     Navigator.of(context).pop();
                //   },
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class NotesView extends StatelessWidget {
  final StorageUser storageUser;

  NotesView(this.storageUser, {Key? key}) : super(key: key);

  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ListView(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const Text(
              "Your Notes",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 18),
            const Center(
              child: Text(
                "Your notes are displayed below  \nUse the button to create a note",
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 48),
            NoteList(storageUser: storageUser),
            const SizedBox(height: 18),
            // ElevatedButton(
            //   child: const Text("ADD NOTE"),
            //   onPressed: _showcontent,
            //   style: ElevatedButton.styleFrom(
            //   primary: Colors.black,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(50),
            //   ),
            // ),
            // ),

            // Column(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     const Text(
            //       "Welcome Back",
            //       style: TextStyle(
            //         color: Colors.black,
            //         fontSize: 28,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //     const SizedBox(height: 48),
            //     Text(storageUser.name),
            //     const SizedBox(height: 48),
            //     TextField(
            //       controller: _nameController,
            //       decoration: const InputDecoration(labelText: 'Name'),
            //     ),
            //     const SizedBox(
            //       height: 8,
            //     ),
            //     Stack(
            //       children: [
            //         ElevatedButton(
            //           child: Text("save"),
            //           onPressed: () {
            //             context.read<StorageUserCubit>().saveUserData(
            //               context.read<AppBloc>().state.user,
            //               context.read<AppBloc>().state.user.id,
            //               _nameController.text,
            //               [],
            //             );
            //           },
            //         ),
            //       ],
            //     )
            //     //_LoginButton(),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}

class NoteList extends StatelessWidget {
  final StorageUser storageUser;

  const NoteList({
    Key? key,
    required this.storageUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        ...storageUser.notes.map((note) => NoteCard(note: note)).toList()
      ],
    );
  }
}

class NoteCard extends StatelessWidget {
  const NoteCard({
    Key? key,
    required this.note,
  }) : super(key: key);

  final Note note;

  @override
  Widget build(BuildContext context) {
    final Color noteColor = Color(int.parse(note.color));
    return InkWell(
      onTap: () {},
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        height: MediaQuery.of(context).size.width / 3,
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            width: 2,
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300]!,
              blurRadius: 8,
              offset: const Offset(0, 7),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
              child: Container(
                color: noteColor,
                height: 10.0,
                width: 10.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(7),
              child: Text(note.title),
            )
          ],
        ),
      ),
    );
  }
}
