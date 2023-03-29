package com.memshelf.memshelf.domain.usecases

import com.memshelf.memshelf.domain.entities.Note
import com.memshelf.memshelf.domain.repositories.NoteRepository
import kotlinx.coroutines.flow.Flow

class GetNotesUseCase(private val repository: NoteRepository) {

    //this is like the call() method in Dart
    operator fun invoke() : Flow<List<Note>> {
        return repository.getNotes()
    }
}