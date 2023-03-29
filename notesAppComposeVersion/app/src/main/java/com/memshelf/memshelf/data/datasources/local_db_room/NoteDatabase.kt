package com.memshelf.memshelf.data.datasources.local_db_room

import androidx.room.Database
import androidx.room.RoomDatabase
import com.memshelf.memshelf.domain.entities.Note

@Database(
    entities = [Note::class],
    version = 1
)
abstract class NoteDatabase: RoomDatabase() {

    abstract val noteDao: NoteDao

    // equivalent to a static element of a class
    companion object {
        const val DATABASE_NAME = "memshelf_db"
    }
}