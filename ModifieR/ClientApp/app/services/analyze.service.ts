import { Observable } from 'rxjs/Observable'
import { Injectable } from '@angular/core';
import { Subject } from 'rxjs/Subject';
import { Http } from '@angular/http'
import { HttpClient } from '@angular/common/http';
import { ModifierInput } from '../models/ModifierInput';
import { Algorithms } from '../models/Algorithms';
import { Router } from '@angular/router';


@Injectable()
export class AnalyzeService {
    constructor(private _httpService: Http, private httpClient: HttpClient, public router: Router) { }

    private error = new Subject<String>();
    error$ = this.error.asObservable();

    public async handleError (error: Response) {
        console.log("Error: ", await error.text());
        this.router.navigateByUrl('/error');
        this.error.next(await error.text());
    }

    async performAnalysis(modifierInput: ModifierInput, algorithm: string, algorithms: Algorithms): Promise<string> {
       let returns: any[] = [];
       console.log('Uploading input data :)' + modifierInput.group1Label);
       let resp: string = '';

        if (algorithm === 'diamond' && algorithms.diamond === true) {
            const post: any = this._httpService.post("/api/analysis/diamond", modifierInput);
            return await post.toPromise().then((response: any) => response.text()).catch((resp: any) => this.handleError(resp));
        }

 
        else if (algorithm === 'cliqueSum' && algorithms.cliqueSum === true) {
            const post: any = this._httpService.post("/api/analysis/cliqueSum", modifierInput)
            return await post.toPromise().then((response: any) => response.text()).catch((resp: any) => this.handleError(resp));
        }

        else if (algorithm === 'mcode' && algorithms.mcode === true) {
           const post: any = this._httpService.post("/api/analysis/mcode", modifierInput)
            return await post.toPromise().then((response: any) => response.text()).catch((resp: any) => this.handleError(resp));
        }
        
        else if (algorithm === 'md' && algorithms.md === true) {
            const post: any = this._httpService.post("/api/analysis/modulediscoverer", modifierInput)
            return await post.toPromise().then((response: any) => response.text()).catch((resp: any) => this.handleError(resp));
        }

        else if (algorithm === 'correlationClique' && algorithms.correlationclique === true) {
            const post: any = this._httpService.post("/api/analysis/correlationclique", modifierInput)
            return await post.toPromise().then((response: any) => response.text()).catch((resp: any) => this.handleError(resp));
       }

        else if (algorithm === 'moda' && algorithms.moda === true) {
            const post: any = this._httpService.post("/api/analysis/moda", modifierInput)
            return await post.toPromise().then((response: any) => response.text()).catch((resp: any) => this.handleError(resp));
       }

        else if (algorithm === 'dime' && algorithms.dime === true) {
            const post: any = this._httpService.post("/api/analysis/dime", modifierInput)
            return await post.toPromise().then((response: any) => response.text()).catch((resp: any) => this.handleError(resp));
       }

        else if (algorithm === 'diffCoEx' && algorithms.diffcoex === true) {
            const post: any = this._httpService.post("/api/analysis/diffcoex", modifierInput)
            return await post.toPromise().then((response: any) => response.text()).catch((resp: any) => this.handleError(resp));
       }
       else {       
           return await Promise.resolve(123)
               .then((res) => {
                   return "NotActive";
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
    }

    async saveFiles(modifierInput: ModifierInput): Promise<string> {
        const post: any = this._httpService.post("/api/analysis/saveFiles", modifierInput)
        return await post.toPromise().then((response: any) => response.text());
    }
    async deleteFiles(modifierInput: ModifierInput): Promise<string> {
        console.log('inputting id: ', modifierInput.id);
        const post: any = this._httpService.post("/api/analysis/deleteFiles", modifierInput)
        return await post.toPromise().then((response: any) => response.text());
    }

    async comboResults(modifierInput: ModifierInput): Promise<string> {
        const post: any = this._httpService.post("/api/analysis/comboResults", modifierInput)
        return await post.toPromise().then((response: any) => response.text()).catch((resp: any) => this.handleError(resp));
    }

    async getResults(id: string[]): Promise<string>{
        const post: any = this._httpService.post("/api/analysis/results", id)
        let res = '';
        await post.toPromise()
            .then((response: any) =>
                res = response.text());
        if (res != '') {
                return await post.toPromise()
                    .then((response: any) =>
                        [this.downloadFile(response.text()), response.text()])
                
        }
        else {
            return await Promise.resolve(123)
                .then((res) => {
                    return "";
                })
        }
    }

    getResultImage(id: string[]): Observable<Blob> {
        var url = 'https://string-db.org/api/image/network?identifiers=';
        for (let i of id) {
            url = url + i + '%0d';
        }
        url = url.substring(0, (url.length - 3));
        url = url + '&add_white_nodes=10&add_color_nodes=10&network_flavor=actions&species=9606';
        console.log('Using url: ', url);
        return this.httpClient
            //.get('https://string-db.org/api/image/network?identifiers=2288%0d6376&add_white_nodes=10&add_color_nodes=10&network_flavor=actions&species=9606',
.get(url,
        {
                responseType: "blob"
            });
    }




 
}
