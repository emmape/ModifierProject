import { Observable } from 'rxjs/Observable'
import { Injectable } from '@angular/core';
import { Subject } from 'rxjs/Subject';
import { Http } from '@angular/http'
import { ModifierInput } from '../models/ModifierInput';
import { Algorithms } from '../models/Algorithms';


@Injectable()
export class InputParametersService {
  constructor(private _httpService: Http) { }

   inputExpressionMatrix(file: any): Promise<string> {
      let formData = new FormData();
      formData.append("file", file);
      let sampleNames: any;
      const post: any = this._httpService.post("/api/input/expressionMatrix", formData)
      return post.toPromise()
        .then((response: any)=> response.text());
  }
   inputProbeMap(file: any): Promise<string> {
       console.log('uploading probe map!!!');
       let formData = new FormData();
       formData.append("file", file);
       const post: any = this._httpService.post("/api/input/probeMap", formData)
       return post.toPromise()
           .then((response: any) => response.text());
   }

   performAnalysis(modifierInput: ModifierInput, algorithms: Algorithms): Promise<string> {
       console.log('Uploading input data :)' + modifierInput.group1Label);
       //let formData = new FormData();
       //formData.append("file", file);
       let resp: string = '';
       if (algorithms.diamond === true) {
           const post: any = this._httpService.post("/api/analysis/diamond", modifierInput)
           return post.toPromise()
               .then((response: any) => response.text());
       } else if (algorithms.barrenas === true) {
           const post: any = this._httpService.post("/api/analysis/barrenas", modifierInput)
           return post.toPromise()
               .then((response: any) => response.text());
       } else if (algorithms.mcode === true) {
           const post: any = this._httpService.post("/api/analysis/mcode", modifierInput)
           return post.toPromise()
               .then((response: any) => response.text());
       } else if (algorithms.md === true) {
           const post: any = this._httpService.post("/api/analysis/md", modifierInput)
           return post.toPromise()
               .then((response: any) => response.text());
       } else {
           const post: any = this._httpService.post("/api/input/probeMap", modifierInput)
           return post.toPromise()
               .then((response: any) => response.text());
       }
       
   }

 
}
