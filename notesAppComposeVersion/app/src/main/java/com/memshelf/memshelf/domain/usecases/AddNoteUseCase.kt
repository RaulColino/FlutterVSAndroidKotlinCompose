package com.memshelf.memshelf.domain.usecases

import com.memshelf.memshelf.domain.entities.InvalidNoteException
import com.memshelf.memshelf.domain.entities.Note
import com.memshelf.memshelf.domain.repositories.NoteRepository

class AddNoteUseCase(private val repository: NoteRepository) {

    //this is like the call() method in Dart
    @Throws(InvalidNoteException::class)
    suspend operator fun invoke(note: Note){
        if(note.title.isBlank()){
            throw InvalidNoteException("Note title can't be empty")
        }
        repository.addNote(note)
    }
}