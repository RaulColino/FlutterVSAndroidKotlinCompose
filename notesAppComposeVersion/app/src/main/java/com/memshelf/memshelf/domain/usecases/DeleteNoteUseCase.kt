package com.memshelf.memshelf.domain.usecases

import com.memshelf.memshelf.domain.entities.Note
import com.memshelf.memshelf.domain.repositories.NoteRepository

class DeleteNoteUseCase(private val repository: NoteRepository) {

    //this is like the call() method in Dart
    suspend operator fun invoke(note:Note) {
        repository.removeNote(note)
    }
}