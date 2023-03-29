package com.memshelf.memshelf.di

import android.app.Application
import androidx.room.Room
import com.memshelf.memshelf.data.datasources.local_db_room.NoteDatabase
import com.memshelf.memshelf.data.repositories.NoteRepositoryLocalDBRoom
import com.memshelf.memshelf.domain.repositories.NoteRepository
import com.memshelf.memshelf.domain.usecases.AddNoteUseCase
import com.memshelf.memshelf.domain.usecases.DeleteNoteUseCase
import com.memshelf.memshelf.domain.usecases.GetNoteByIdUseCase
import com.memshelf.memshelf.domain.usecases.GetNotesUseCase
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

//In Kotlin, object is a special class that only has one instance
@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    @Provides
    @Singleton
    fun provideLocalDatabaseRoom(app: Application): NoteDatabase {
        return Room.databaseBuilder(
            app,
            NoteDatabase::class.java,
            NoteDatabase.DATABASE_NAME
        ).build()
    }

    @Provides
    @Singleton
    fun providerNoteRepository(db: NoteDatabase) : NoteRepository {
        return NoteRepositoryLocalDBRoom(db.noteDao)
    }

    @Provides
    @Singleton
    fun provideGetNotesUseCase(repository: NoteRepository) : GetNotesUseCase {
        return GetNotesUseCase(repository)
    }

    @Provides
    @Singleton
    fun provideDeleteNoteUseCase(repository: NoteRepository) : DeleteNoteUseCase {
        return DeleteNoteUseCase(repository)
    }

    @Provides
    @Singleton
    fun provideAddNoteUseCase(repository: NoteRepository) : AddNoteUseCase {
        return AddNoteUseCase(repository)
    }

    @Provides
    @Singleton
    fun provideGetNoteByIdUseCase(repository: NoteRepository) : GetNoteByIdUseCase {
        return GetNoteByIdUseCase(repository)
    }


}