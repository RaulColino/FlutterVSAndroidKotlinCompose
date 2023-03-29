package com.memshelf.memshelf.presentation.view_models.NoteDetail

import androidx.compose.ui.focus.FocusState

sealed class NoteDetailEvent {
    data class EnteredTitleText(val value: String): NoteDetailEvent()
    data class ChangeTitleTextFocus(val focusState: FocusState): NoteDetailEvent()

    data class EnteredBodyText(val value: String): NoteDetailEvent()
    data class ChangeBodyTextFocus(val focusState: FocusState): NoteDetailEvent()

    data class ChangeColor(val color: Int): NoteDetailEvent()

    object SaveNote: NoteDetailEvent()

}