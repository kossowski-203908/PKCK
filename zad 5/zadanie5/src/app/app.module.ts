import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppComponent } from './app.component';
import { SerializeService } from './services/serialize.service';
import { FileService } from './services/file.service';
import { TransformComponent } from './transform/transform.component';
import {FormsModule} from "@angular/forms";
import { ContentComponent } from './content/content.component';
import { DepartmentContentComponent } from './department-content/department-content.component';
import { CreatorContentComponent } from './creator-content/creator-content.component';
import { BooksContentComponent } from './books-content/books-content.component';

@NgModule({
  declarations: [
    AppComponent,
    TransformComponent,
    ContentComponent,
    DepartmentContentComponent,
    CreatorContentComponent,
    BooksContentComponent
  ],
  imports: [
    BrowserModule,
    FormsModule
  ],
  providers: [SerializeService, FileService],
  bootstrap: [AppComponent]
})
export class AppModule { }
