import { Observable } from 'rxjs/Observable';
import { of } from 'rxjs/observable/of';
import { Injectable } from '@angular/core';
import { Subject } from 'rxjs/Subject';
import { ReadFile } from '../models/readFile.model';

@Injectable()
export class ReadFileService {

  constructor() { }

  private file = new Subject<ReadFile>();
  file$ = this.file.asObservable();
  fileUploaded(f: ReadFile) {
    this.file.next(f);
  }
  //private samples = new Subject<string>();
  //samples$ = this.samples.asObservable();
  //samplesRecieved(s: string) {
  //    this.samples.next(s);
  //  }

    private combo = new Subject<string>();
    combo$ = this.combo.asObservable();
    comboRecieved(s: string) {
        this.combo.next(s);
    }

}
