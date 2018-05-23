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
    result: string = '!';

    id: string = '';

    constructor(private readFileService: ReadFileService, public dialog: MatDialog,
        private _formBuilder: FormBuilder, public analyzeService: AnalyzeService, private activatedRoute: ActivatedRoute) {
        }
    

    ngOnInit() {
        this.activatedRoute.params.subscribe((params: Params) => {
            this.id = params['id'];
            console.log(this.id);
        });   
        this.getResults();
       Observable.interval(2000 * 60).subscribe(x => {
           this.getResults();
       });
    }
    async getResults() {
        await Promise.resolve(
            this.analyzeService.getResults(['diamond', this.id])
        ).then(r => this.resultDiamond = r);

        await Promise.resolve(
            this.analyzeService.getResults(['cliqueSum', this.id])
        ).then(r => this.resultCliquesum = r);

        await Promise.resolve(
            this.analyzeService.getResults(['correlationClique', this.id])
        ).then(r => this.resultCorrelationClique = r);

        await Promise.resolve(
            this.analyzeService.getResults(['diffCoEx', this.id])
        ).then(r => this.resultDiffCoEx = r);

        await Promise.resolve(
            this.analyzeService.getResults(['dime', this.id])
        ).then(r => this.resultDime = r);

        await Promise.resolve(
            this.analyzeService.getResults(['mcode', this.id])
        ).then(r => this.resultMcode = r);

        await Promise.resolve(
            this.analyzeService.getResults(['moda', this.id])
        ).then(r => this.resultModa = r);

        await Promise.resolve(
            this.analyzeService.getResults(['moduleDiscoverer', this.id])
        ).then(r => this.resultModuleDiscoverer = r);

        if (this.resultDiamond != '') {
            this.chosenAlgorithms.push('Diamond');
        }
        if (this.resultMcode != '') {
            this.chosenAlgorithms.push('MCODE');
        }
        if (this.resultModuleDiscoverer != '') {
            this.chosenAlgorithms.push('ModuleDiscoverer');
        }
        if (this.resultModa != '') {
            this.chosenAlgorithms.push('Moda');
        }
        if (this.resultDime != '') {
            this.chosenAlgorithms.push('Dime');
        }
        if (this.resultDiffCoEx != '') {
            this.chosenAlgorithms.push('DiffCoEx');
        }
        if (this.resultCorrelationClique != '') {
            this.chosenAlgorithms.push('CorrelationClique');
        }
        if (this.resultCliquesum != '') {
            this.chosenAlgorithms.push('CliqueSum');
        }
    }
    
}