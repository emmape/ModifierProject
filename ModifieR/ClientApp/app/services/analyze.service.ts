import { Observable } from 'rxjs/Observable'
import { Injectable } from '@angular/core';
import { Subject } from 'rxjs/Subject';
import { Http } from '@angular/http'
import { ModifierInput } from '../models/ModifierInput';
import { Algorithms } from '../models/Algorithms';


@Injectable()
export class AnalyzeService {
  constructor(private _httpService: Http) { }

   performAnalysis(modifierInput: ModifierInput, algorithms: Algorithms): Promise<string> {
       console.log('Uploading input data :)' + modifierInput.group1Label);
       let resp: string = '';
       if (algorithms.diamond === true) {
           const post: any = this._httpService.post("/api/analysis/diamond", modifierInput)
           let s: Promise<string> = post.toPromise().then((response: any) => response.text());
           return Promise.resolve(123)
               .then((res) => {
                   return "An email will be sent to you once the results are finished :) \n This could take a while, up to 24 hours. \ If you have any questions, please send an email to modifiermail@gmail.com";
               })
       } else if (algorithms.cliquesum === true) {
           const post: any = this._httpService.post("/api/analysis/cliquesum", modifierInput)
           return post.toPromise()
               .then((response: any) =>
                   this.downloadFile(response.text()));
                   //response.text());
       } else if (algorithms.mcode === true) {
           const post: any = this._httpService.post("/api/analysis/mcode", modifierInput)
           return post.toPromise()
               .then((response: any) => response.text());
       } else if (algorithms.md === true) {
           const post: any = this._httpService.post("/api/analysis/modulediscoverer", modifierInput)
           return post.toPromise()
               .then((response: any) => response.text());
       } else if (algorithms.correlationclique === true) {
           const post: any = this._httpService.post("/api/analysis/correlationclique", modifierInput)
           return post.toPromise()
               .then((response: any) => response.text());
       }
       else if (algorithms.moda === true) {
           const post: any = this._httpService.post("/api/analysis/moda", modifierInput)
           return post.toPromise()
               .then((response: any) => response.text());
       }
       else if (algorithms.dime === true) {
           const post: any = this._httpService.post("/api/analysis/dime", modifierInput)
           return post.toPromise()
               .then((response: any) => response.text());
       }
       else if (algorithms.diffcoex === true) {
           const post: any = this._httpService.post("/api/analysis/diffcoex", modifierInput)
           return post.toPromise()
               .then((response: any) => response.text());
       } else {       
           return Promise.resolve(123)
               .then((res) => {
                   return "Error";
               })
       }
       
  }

   downloadFile(data: Response): any {
       var blob = new Blob([data], { type: 'text/csv' });
       var url = window.URL.createObjectURL(blob);
       var anchor = document.createElement("a");
       anchor.download = "ModifieRanalysis.csv";
       anchor.href = url;
       return anchor; 
       //anchor.click()
      // window.open(url);
   }

 
}
