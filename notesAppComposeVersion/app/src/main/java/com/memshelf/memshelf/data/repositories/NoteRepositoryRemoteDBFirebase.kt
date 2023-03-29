package com.memshelf.memshelf.data.repositories

import android.util.Log
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import com.memshelf.memshelf.domain.entities.Note
import com.memshelf.memshelf.domain.entities.Result
import com.memshelf.memshelf.domain.entities.StorageUser
import com.memshelf.memshelf.domain.repositories.NoteRepository
import com.memshelf.memshelf.domain.repositories.RemoteNoteRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import java.lang.Exception

class NoteRepositoryRemoteDBFirebase() : RemoteNoteRepository {

    //Firestore instance
    val db = Firebase.firestore


    override fun getNotes(userId: String): Flow<List<Note>> = flow {
        try {
            val document = db.collection("user/${userId}").document()
            val noteList = document.get().addOnSuccessListener { snapshot ->
                val x = snapshot.toObject(StorageUser::class.java)
            }

        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    override suspend fun addNote(note: Note, userId: String) {
        TODO("Not yet implemented")
    }

    override suspend fun updateNote(note: Note, userId: String) {
        TODO("Not yet implemented")
    }

    override suspend fun removeNote(note: Note, userId: String) {
        TODO("Not yet implemented")
    }

    private fun saveNotes(userId: String, notesList: List<Note>) {
        try {
            val document = db.collection("user/${userId}").document()

        } catch (e: Exception) {
            e.printStackTrace()
        }
    }


    //    override fun getNotes(userId: String): Flow<List<Note>> {
//        db.collection("user/${userId}")
//            .get()
//            .addOnSuccessListener { result ->
//                for (document in result) {
//
//                }
//            }
//            .addOnFailureListener { exception ->
//
//            }
//
//    }


}