package com.memshelf.memshelf.presentation.view_models.home

import com.memshelf.memshelf.domain.entities.Note

sealed class HomeEvent {
    data class DeleteNote(val note: Note): HomeEvent()
    object RestoreNote: HomeEvent()
    object SignOut : HomeEvent()
}
