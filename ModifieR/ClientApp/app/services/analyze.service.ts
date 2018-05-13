import { Observable } from 'rxjs/Observable'
import { Injectable } from '@angular/core';
import { Subject } from 'rxjs/Subject';
import { Http } from '@angular/http'
import { ModifierInput } from '../models/ModifierInput';
import { Algorithms } from '../models/Algorithms';


@Injectable()
export class AnalyzeService {
  constructor(private _httpService: Http) { }

    async performAnalysis(modifierInput: ModifierInput, algorithm: string, algorithms: Algorithms): Promise<string> {
       let returns: any[] = [];
       console.log('Uploading input data :)' + modifierInput.group1Label);
       let resp: string = '';
       //if (algorithms.diamond === true) {
        if (algorithm === 'diamond' && algorithms.diamond === true) {
           const post: any = this._httpService.post("/api/analysis/diamond", modifierInput)
           let s: Promise<string> = post.toPromise().then((response: any) => response.text());
          // returns.push(
               return( await Promise.resolve(123)
               .then((res) => {
                   return "An email will be sent to you once the results are finished :) \n This could take a while, up to 24 hours. \ If you have any questions, please send an email to modifiermail@gmail.com";
        }));
        }
        //if (algorithms.cliquesum === true) {
        else if (algorithm === 'cliqueSum' && algorithms.cliquesum === true) {
           const post: any = this._httpService.post("/api/analysis/cliquesum", modifierInput)
            return await post.toPromise()
               .then((response: any) =>
                   this.downloadFile(response.text()));
                   //response.text());
            //console.log(r);
            //returns.push(r);
        }
        //if (algorithms.mcode === true) {
        else if (algorithm === 'mcode' && algorithms.mcode === true) {
           const post: any = this._httpService.post("/api/analysis/mcode", modifierInput)
           return await (post.toPromise()
               .then((response: any) => response.text()));
        }
        //if (algorithms.md === true) {
        else if (algorithm === 'md' && algorithms.md === true) {
           const post: any = this._httpService.post("/api/analysis/modulediscoverer", modifierInput)
           return await (post.toPromise()
               .then((response: any) => response.text()));
        }
        //if (algorithms.correlationclique === true) {
        else if (algorithm === 'correlationClique' && algorithms.correlationclique === true) {
           const post: any = this._httpService.post("/api/analysis/correlationclique", modifierInput)
           return await (post.toPromise()
               .then((response: any) => response.text()));
       }

        //if (algorithms.moda === true) {
        else if (algorithm === 'moda' && algorithms.moda === true) {
           const post: any = this._httpService.post("/api/analysis/moda", modifierInput)
           return await (post.toPromise()
               .then((response: any) => response.text()));
       }

        //if (algorithms.dime === true) {
        else if (algorithm === 'dime' && algorithms.dime === true) {
           const post: any = this._httpService.post("/api/analysis/dime", modifierInput)
           return await (post.toPromise()
               .then((response: any) => response.text()));
       }
        //if (algorithms.diffcoex === true) {
        else if (algorithm === 'diffCoEx' && algorithms.diffcoex === true) {
           const post: any = this._httpService.post("/api/analysis/diffcoex", modifierInput)
           return await(post.toPromise()
               .then((response: any) => response.text()));
       }
       else {       
           return await Promise.resolve(123)
               .then((res) => {
                   return "NotActive";
               })
        }

        //return returns;
       
  }

   downloadFile(data: Response): any {
       var blob = new Blob([data], { type: 'text/csv' });
       var url = window.URL.createObjectURL(blob);
       var anchor = document.createElement("a");
       anchor.download = "ModifieRanalysis.csv";
       anchor.href = url;
      
       anchor.click();
       return anchor; 
       //window.open(url);
      // return "some return";
   }

 
}
