package com.memshelf.memshelf.presentation.view_models.NoteDetail

import androidx.compose.runtime.State
import androidx.compose.runtime.mutableStateOf
import androidx.compose.ui.graphics.toArgb
import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.SetOptions
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import com.google.type.Color
import com.memshelf.memshelf.domain.entities.InvalidNoteException
import com.memshelf.memshelf.domain.entities.Note
import com.memshelf.memshelf.domain.entities.RemoteNote
import com.memshelf.memshelf.domain.entities.StorageUser
import com.memshelf.memshelf.domain.usecases.AddNoteUseCase
import com.memshelf.memshelf.domain.usecases.GetNoteByIdUseCase
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.launch
import java.lang.Exception
import javax.inject.Inject

@HiltViewModel
class NoteDetailViewModel @Inject constructor(
    private val addNoteUseCase: AddNoteUseCase,
    private val getNoteByIdUseCase: GetNoteByIdUseCase,
    savedStateHandle: SavedStateHandle
) : ViewModel() {

    private val db = Firebase.firestore
    private val auth: FirebaseAuth = FirebaseAuth.getInstance()

    //A mutableState in jetpack compose is a value that the UI can observe so whenever it changes the UI updates.
    //A mutable state should only be modified in the ViewModel
    private val _noteTitle = mutableStateOf(NoteTextFieldState(hintText = "Enter title here..."))
    val noteTitle: State<NoteTextFieldState> = _noteTitle

    private val _noteBody = mutableStateOf(NoteTextFieldState(hintText = "Enter your text here..."))
    val noteBody: State<NoteTextFieldState> = _noteBody

    private val _noteColor = mutableStateOf(Note.noteColors.first().toArgb())
    val noteColor: State<Int> = _noteColor

    private val _eventFlow = MutableSharedFlow<UiEvent>()
    val eventFlow = _eventFlow.asSharedFlow()

    private var currentNoteId: Int? = null

    init {
        savedStateHandle.get<Int>("noteId")?.let { noteId ->
            if (noteId != -1) {
                viewModelScope.launch {
//                    getNoteByIdUseCase(noteId)?.also { note ->
//                        currentNoteId = note.id
//                        _noteTitle.value = noteTitle.value.copy(
//                            text = note.title,
//                            isHintVisible = false
//                        )
//                        _noteBody.value = noteBody.value.copy(
//                            text = note.body,
//                            isHintVisible = false
//                        )
//                        _noteColor.value = note.color.toInt()
//                    }
                }
            }
        }
    }

    fun onEvent(event: NoteDetailEvent) {
        when (event) {
            is NoteDetailEvent.EnteredTitleText -> {
                _noteTitle.value = noteTitle.value.copy(
                    text = event.value
                )
            }
            is NoteDetailEvent.ChangeTitleTextFocus -> {
                _noteTitle.value = noteTitle.value.copy(
                    isHintVisible = !event.focusState.isFocused && noteTitle.value.text.isBlank()
                )
            }
            is NoteDetailEvent.EnteredBodyText -> {
                _noteBody.value = noteBody.value.copy(
                    text = event.value
                )
            }
            is NoteDetailEvent.ChangeBodyTextFocus -> {
                _noteBody.value = noteBody.value.copy(
                    isHintVisible = !event.focusState.isFocused && noteBody.value.text.isBlank()
                )
            }
            is NoteDetailEvent.ChangeColor -> {
                _noteColor.value = event.color
            }
            is NoteDetailEvent.SaveNote -> {
                viewModelScope.launch {
                    try {
//                        addNoteUseCase(
//                            Note(
//                                title = noteTitle.value.text,
//                                body = noteBody.value.text,
//                                color = noteColor.value.toString(),
//                                id = currentNoteId
//                            )
//                        )
                        addNoteToRemoteStorage(
                            Note(
                                title = noteTitle.value.text,
                                body = noteBody.value.text,
                                color = noteColor.value.toString(),
                                id = currentNoteId
                            )
                        )
                        _eventFlow.emit(UiEvent.SaveNote)
                    } catch (e: InvalidNoteException) {
                        _eventFlow.emit(
                            UiEvent.ShowSnackbar(
                                message = e.message
                                    ?: "An error occurred when saving the note. Try again."
                            )
                        )
                    }
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

                    val newNote = RemoteNote(title = note.title, color = "0xffffab91", category = "1", body = note.body,)

                    val updatedNotesList = storageUser.notes.toList().toMutableList()
                    updatedNotesList.add(newNote)

                    val updatedStorageUser = StorageUser(storageUser.id,storageUser.name,updatedNotesList)


                    document.set(updatedStorageUser, SetOptions.merge())

                }else{
                    print("no notes received from remote storage")
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    sealed class UiEvent {
        data class ShowSnackbar(val message: String) : UiEvent()
        object SaveNote : UiEvent()
    }

}