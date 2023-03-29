package com.memshelf.memshelf.domain.usecases

import com.memshelf.memshelf.domain.entities.Note
import com.memshelf.memshelf.domain.repositories.NoteRepository

class GetNoteByIdUseCase(private val repository: NoteRepository) {

    suspend operator fun invoke(id: Int): Note? {
        return repository.getNoteById(id)
    }
}