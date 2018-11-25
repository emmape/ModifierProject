import { Component, OnInit, Inject } from '@angular/core';
import { FileUploaderComponent } from '../components/file-uploader/file-uploader.component';
import { ReadFileService } from '../services/readFile.service';
import { AnalyzeService } from '../services/analyze.service';
import { MissingDialog } from '../components/dialog/missingDialog.component';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { ModifierInput } from '../models/ModifierInput';
import { Algorithms } from '../models/Algorithms';
import { forEach } from '@angular/router/src/utils/collection';
import { Router, ActivatedRoute, Params } from '@angular/router';
import { Observable } from 'rxjs/Rx';


@Component({
    selector: 'app-result',
    templateUrl: './result.component.html',
    styleUrls: ['./result.component.css']
})
export class ResultComponent implements OnInit {
    chosenAlgorithms: string[] = [];
    resultDiamond: any='';
    resultCliquesum: any='';
    resultMcode: any='';
    resultModa: any='';
    resultModuleDiscoverer: any='';
    resultCorrelationClique: any='';
    resultDime: any='';
    resultDiffCoEx: any = '';
    resultCombo: any = '';
    result: string = '!';
    subscription: any = '';
    comboGenes: string[] = [];
    comboImage: any = '';

    id: string = '';

    constructor(private readFileService: ReadFileService, public dialog: MatDialog,
        private _formBuilder: FormBuilder, public analyzeService: AnalyzeService, private activatedRoute: ActivatedRoute) {
        }
    

    ngOnInit() {
        this.activatedRoute.params.subscribe((params: Params) => {
            this.id = params['id'];
            console.log(this.id);
        });   
        console.log('Getting reults');
        this.getResults();

        this.subscription = Observable.interval(2000 * 10).takeUntil(this.readFileService.combo$).subscribe(x => {
                console.log('Getting reults again...');
                this.getResults().catch();
        });
 
           // this.subscription.unsubscribe();
           // console.log('BLOB: ', this.resultCombo);
       
        
    }
    async getResults() {
        await Promise.resolve(
            this.analyzeService.getResults(['diamond', this.id])
        ).then(r => this.resultDiamond = r[0]);

        await Promise.resolve(
            this.analyzeService.getResults(['cliqueSum', this.id])
        ).then(r => this.resultCliquesum = r[0]);

        await Promise.resolve(
            this.analyzeService.getResults(['correlationClique', this.id])
        ).then(r => this.resultCorrelationClique = r[0]);

        await Promise.resolve(
            this.analyzeService.getResults(['diffCoEx', this.id])
        ).then(r => this.resultDiffCoEx = r[0]);

        await Promise.resolve(
            this.analyzeService.getResults(['dime', this.id])
        ).then(r => this.resultDime = r[0]);

        await Promise.resolve(
            this.analyzeService.getResults(['mcode', this.id])
        ).then(r => this.resultMcode = r[0]);

        await Promise.resolve(
            this.analyzeService.getResults(['moda', this.id])
        ).then(r => this.resultModa = r[0]);

        await Promise.resolve(
            this.analyzeService.getResults(['moduleDiscoverer', this.id])
        ).then(r => this.resultModuleDiscoverer = r[0]);

        await Promise.resolve(
            this.analyzeService.getResults(['combo', this.id])
        ).then(r => this.gotCombo(r));
       
        if (this.resultDiamond != undefined  && this.chosenAlgorithms.indexOf('Diamond') < 0) {
            this.chosenAlgorithms.push('Diamond');
        }
        if (this.resultMcode != undefined && this.chosenAlgorithms.indexOf('MCODE') < 0) {
            this.chosenAlgorithms.push('MCODE');
        }
        if (this.resultModuleDiscoverer != undefined && this.chosenAlgorithms.indexOf('ModuleDiscoverer') < 0) {
            this.chosenAlgorithms.push('ModuleDiscoverer');
        }
        if (this.resultModa != undefined && this.chosenAlgorithms.indexOf('Moda') < 0) {
            this.chosenAlgorithms.push('Moda');
        }
        if (this.resultDime != undefined && this.chosenAlgorithms.indexOf('Dime') < 0) {
            this.chosenAlgorithms.push('Dime');
        }
        if (this.resultDiffCoEx != undefined && this.chosenAlgorithms.indexOf('DiffCoEx') < 0) {
            this.chosenAlgorithms.push('DiffCoEx');
        }
        if (this.resultCorrelationClique != undefined && this.chosenAlgorithms.indexOf('CorrelationClique') < 0) {
            this.chosenAlgorithms.push('CorrelationClique');
        }
        if (this.resultCliquesum != undefined && this.chosenAlgorithms.indexOf('CliqueSum') < 0) {
            this.chosenAlgorithms.push('CliqueSum');
        }
    }
    async gotCombo(r: any) {
        this.resultCombo = r[0]
        if (this.resultCombo != undefined) {
            this.readFileService.comboRecieved(r[0]);
            var re = /"/gi; 
            this.comboGenes = r[1].replace(re, '').split('\n').splice(1);
            var blobImage: any = '';

            await this.analyzeService.getResultImage(this.comboGenes).subscribe(data => {
                this.createImageFromBlob(data);
            }, error => {
                console.log(error);
                });
            this.createImageFromBlob(blobImage);
   
        }
    }

    createImageFromBlob(image: Blob) {
        let reader = new FileReader();
        reader.addEventListener("load", () => {
            this.comboImage = reader.result;
        }, false);

        if (image) {
            reader.readAsDataURL(image);
        }
    }
    
}