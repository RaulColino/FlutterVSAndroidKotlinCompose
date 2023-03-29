package com.memshelf.memshelf.presentation.view_models.home

import android.util.Log
import androidx.compose.runtime.State
import androidx.compose.runtime.mutableStateOf
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.SetOptions
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import com.memshelf.memshelf.domain.entities.Note
import com.memshelf.memshelf.domain.entities.RemoteNote
import com.memshelf.memshelf.domain.entities.StorageUser
import com.memshelf.memshelf.domain.usecases.AddNoteUseCase
import com.memshelf.memshelf.domain.usecases.DeleteNoteUseCase
import com.memshelf.memshelf.domain.usecases.GetNotesUseCase
import com.memshelf.memshelf.presentation.view_models.NoteDetail.NoteDetailViewModel
import com.memshelf.memshelf.presentation.view_models.login.LoginViewModel
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import java.lang.Exception
import javax.inject.Inject

@HiltViewModel
class HomeViewModel @Inject constructor(
    private val getNotesUseCase: GetNotesUseCase,
    private val deleteNoteUseCase: DeleteNoteUseCase,
    private val addNoteUseCase: AddNoteUseCase,
) : ViewModel() {

    private val db = Firebase.firestore
    private val auth: FirebaseAuth = FirebaseAuth.getInstance()

    private var _notes = mutableStateOf(emptyList<Note>().toMutableList())
    val notes: State<MutableList<Note>> = _notes

    private val _eventFlow = MutableSharedFlow<HomeViewModel.UiEvent>()
    val eventFlow = _eventFlow.asSharedFlow()

    private var recentlyDeletedNote: Note? = null

    private var getNotesJob: Job? = null

//    private val _state = mutableStateOf(HomeState())
//    val state: State<HomeState> = _state

    //get notes the first time the ViewModel is created
    init {
        //getNotes()
        getNotesFromRemoteStorage()
    }

    fun onEvent(event: HomeEvent) {
        when (event) {
            is HomeEvent.DeleteNote -> {
                viewModelScope.launch {
                    //deleteNoteUseCase(event.note)
                    deleteNoteFromRemoteStorage(event.note)
                    recentlyDeletedNote = event.note
                }
            }
            is HomeEvent.RestoreNote -> {
                viewModelScope.launch {
                    //addNoteUseCase(recentlyDeletedNote ?: return@launch)
                    addNoteToRemoteStorage(recentlyDeletedNote ?: return@launch)
                    recentlyDeletedNote = null
                }
            }
            is HomeEvent.SignOut -> {
                viewModelScope.launch {
                    auth.signOut()
                    _eventFlow.emit(UiEvent.SignOutRequested)
                }
            }
        }
    }


    private fun addNoteToRemoteStorage(note: Note) {
        val userId = auth.currentUser?.uid
        try {
            val document = db.document("user/${userId}")
            val noteList = document.get().addOnSuccessListener { snapshot ->
                val storageUser = snapshot.toObject(StorageUser::class.java)
                if (storageUser != null) {
                    val newNote = RemoteNote(
                        title = note.title,
                        color = "0xffffab91",
                        category = "1",
                        body = note.body,
                    )
                    val updatedNotesList = storageUser.notes.toList().toMutableList()
                    updatedNotesList.add(newNote)
                    val updatedStorageUser =
                        StorageUser(storageUser.id, storageUser.name, updatedNotesList)
                    document.set(updatedStorageUser, SetOptions.merge())
                } else {
                    print("no notes received from remote storage")
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }


    private fun deleteNoteFromRemoteStorage(note: Note) {
        val userId = auth.currentUser?.uid
        try {
            val document = db.document("user/${userId}")
            val noteList = document.get().addOnSuccessListener { snapshot ->
                val storageUser = snapshot.toObject(StorageUser::class.java)
                if (storageUser != null) {
                    val updatedNotesList = _notes.value.toMutableList()
                    updatedNotesList.remove(note)
                    val updatedStorageUserNotes = updatedNotesList.map { n ->
                        RemoteNote(title = n.title, category = "1", color = n.color, body = n.body)
                    }.toList()
                    val updatedStorageUser =
                        StorageUser(storageUser.id, storageUser.name, updatedStorageUserNotes)
                    document.set(updatedStorageUser, SetOptions.merge())
                } else {
                    print("no notes received from remote storage")
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

//    private fun getNotes() {
//        getNotesJob?.cancel()
//        getNotesJob = getNotesUseCase().onEach { notes ->
//            _state.value = state.value.copy(notes = notes)
//        }.launchIn(viewModelScope)
//    }

    private fun getNotesFromRemoteStorage() {
        getNotesJob?.cancel()
        getNotesFromFirebase()
    }

    private fun getNotesFromFirebase() {
        val userId = auth.currentUser?.uid

        try {
            val document = db.document("user/${userId}")
            val noteList = document.addSnapshotListener { snapshot, e ->
                if (e != null) {
                    print("some error happened while listening for notes changes on firebase")
                    return@addSnapshotListener
                }
                val storageUserNotes = emptyList<Note>().toMutableList()
                if (snapshot != null) {
                    val storageUser = snapshot.toObject(StorageUser::class.java)
                    if (storageUser != null) {
                        storageUserNotes.addAll(storageUser.notes.map { note ->
                            Note(title = note.title, body = note.body, color = note.color)
                        }.toList())
                    } else {
                        print("no notes received from remote storage")
                    }
                }
                updateNotesList(storageUserNotes)
            }

        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    fun updateNotesList(noteList: MutableList<Note>) {
        _notes.value = noteList
    }

    sealed class UiEvent {
        object SignOutRequested : UiEvent()
    }

}