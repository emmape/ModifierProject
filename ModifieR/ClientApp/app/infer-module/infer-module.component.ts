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


@Component({
    selector: 'app-infer-module',
    templateUrl: './infer-module.component.html',
    styleUrls: ['./infer-module.component.css']
})
export class InferModuleComponent implements OnInit {

    modifierInputObject: ModifierInput = new ModifierInput();
    algorithms: Algorithms = new Algorithms();
    chosenAlgorithms: string[] = [];
    result: any = '';

    selectedNetwork = '';
    comboChoice = false;
    countSelected = 0;
    firstFormGroup: FormGroup;
    secondFormGroup: FormGroup;
    thirdFormGroup: FormGroup;
    networkFile: any = '';
    networkCtrl = new FormControl('', [Validators.required]);
    groupName1Ctrl = new FormControl('', [Validators.required]);
    groupName2Ctrl = new FormControl('', [Validators.required]);
    algorithmCtrl = new FormControl('');
    samples: string[] = ['S1', 'S2', 'S3', 'S4'];
    originalSamples: string[] = ['S1', 'S2', 'S3', 'S4'];
    dragItem: any = null;
    selectedForDrag: string[] = [];

    networks = [
        { value: 'upload', viewValue: 'Upload a New Network' },
        { value: 'StringPPI', viewValue: 'String PPI' },
        { value: 'other', viewValue: 'Other PPI' }
    ];

    constructor(private readFileService: ReadFileService, public dialog: MatDialog,
        private _formBuilder: FormBuilder, public analyzeService: AnalyzeService) {
        readFileService.file$.subscribe(
            file => {
                if (file.fileType === 'genes') {
                    this.modifierInputObject.expressionMatrixContent = file.file;
                    console.log(this.modifierInputObject.expressionMatrixContent.split('\n')[0].split(' '));
                    this.samples = this.modifierInputObject.expressionMatrixContent.split('\n')[0].split(' ');
                    this.originalSamples = this.modifierInputObject.expressionMatrixContent.split('\n')[0].split(' ');
                } else if (file.fileType === 'network') {
                    this.networkFile = file.file;
                } else if (file.fileType === 'probeMap') {
                    this.modifierInputObject.probeMapContent = file.file;
                }
            });
        //readFileService.samples$.subscribe(
        //    sample => {
        //        this.samples = sample.split(' ');
        //    });
        this.setSecondFormGroupValid();
    }

    ngOnInit() {
        this.firstFormGroup = this._formBuilder.group({
            // geneFileCtrl: this.geneFileCtrl,
            networkCtrl: this.networkCtrl,
        });
        this.secondFormGroup = this._formBuilder.group({
            algorithmCtrl: this.algorithmCtrl,
            // diamondCB: this.diamondCB,
        });
        this.thirdFormGroup = this._formBuilder.group({
            groupName1Ctrl: this.groupName1Ctrl,
            groupName2Ctrl: this.groupName2Ctrl,
        });
    }

    recieveDropG1(e: any) {
        //this.modifierInputObject.sampleGroup1.push(this.dragItem);
        //this.modifierInputObject.sampleGroup1.push((this.originalSamples.indexOf(this.dragItem, 0) + 1).toString());
        for (let i of this.selectedForDrag){
            this.modifierInputObject.sampleGroup1.push((this.originalSamples.indexOf(i, 0) + 1).toString());
        }
        this.dragItem = null;
        this.selectedForDrag = [];
    }
    recieveDropG2(e: any) {
        //this.modifierInputObject.sampleGroup2.push((this.originalSamples.indexOf(this.dragItem, 0)+1).toString());
        for (let i of this.selectedForDrag) {
            this.modifierInputObject.sampleGroup2.push((this.originalSamples.indexOf(i, 0) + 1).toString());
        }
        this.dragItem = null;
        this.selectedForDrag = [];
    }
    dragSample(e: any) {
        if (this.dragItem == null) {
            this.dragItem = e;
            var index = this.samples.indexOf(this.dragItem, 0);
            //if (index > -1) {
            //    this.samples.splice(index, 1);
            //}
            for (let i of this.selectedForDrag) {
                this.samples.splice(this.samples.indexOf(i, 0), 1)
            }
        }
    }
    sampleSelected(event: any, item: any) {
        if (event.checked === true) {
            this.selectedForDrag.push(item);
            console.log('pushing: ' + item);
        } else {
            this.selectedForDrag.splice(this.selectedForDrag.indexOf(item, 0), 1);
            console.log('popping: ' + item);
        }
        
    }

    diamondChbChanged() {
        console.log(this.algorithms.diamond);
        if (this.algorithms.diamond === false) {
            this.algorithms.diamond = true;
            this.chosenAlgorithms.push('Diamond');
            this.countSelected++;
        } else {
            this.algorithms.diamond = false;
            this.chosenAlgorithms.splice(this.chosenAlgorithms.indexOf('Diamond', 0), 1)
            this.countSelected--;
        }
        if (this.countSelected > 1) {
            this.comboChoice = true;
        } else {
            this.comboChoice = false;
        }
        this.setSecondFormGroupValid();
    }
    mcodeChbChanged() {
        if (this.algorithms.mcode === false) {
            this.algorithms.mcode = true;
            this.chosenAlgorithms.push('MCODE');
            this.countSelected++;
        } else {
            this.algorithms.mcode = false;
            this.chosenAlgorithms.splice(this.chosenAlgorithms.indexOf('MCODE', 0), 1)
            this.countSelected--;
        }
        if (this.countSelected > 1) {
            this.comboChoice = true;
        } else {
            this.comboChoice = false;
        }
        this.setSecondFormGroupValid();
    }
    mdChbChanged() {
        if (this.algorithms.md === false) {
            this.algorithms.md = true;
            this.chosenAlgorithms.push('ModuleDiscoverer');
            this.countSelected++;
        } else {
            this.algorithms.md = false;
            this.chosenAlgorithms.splice(this.chosenAlgorithms.indexOf('ModuleDiscoverer', 0), 1)
            this.countSelected--;
        }
        if (this.countSelected > 1) {
            this.comboChoice = true;
        } else {
            this.comboChoice = false;
        }
        this.setSecondFormGroupValid();
    }
    cliquesumChbChanged() {
        if (this.algorithms.cliquesum === false) {
            this.algorithms.cliquesum = true;
            this.chosenAlgorithms.push('CliqueSum');
            this.countSelected++;
        } else {
            this.algorithms.cliquesum = false;
            this.chosenAlgorithms.splice(this.chosenAlgorithms.indexOf('CliqueSum', 0), 1)
            this.countSelected--;
        }
        if (this.countSelected > 1) {
            this.comboChoice = true;
        } else {
            this.comboChoice = false;
        }
        this.setSecondFormGroupValid();
    }
    correlationcliqueChbChanged() {
        if (this.algorithms.correlationclique === false) {
            this.algorithms.correlationclique = true;
            this.chosenAlgorithms.push('CorrelationClique');
            this.countSelected++;
        } else {
            this.algorithms.correlationclique = false;
            this.chosenAlgorithms.splice(this.chosenAlgorithms.indexOf('CorrelationClique', 0), 1)
            this.countSelected--;
        }
        if (this.countSelected > 1) {
            this.comboChoice = true;
        } else {
            this.comboChoice = false;
        }
        this.setSecondFormGroupValid();
    }
    diffcoexChbChanged() {
        if (this.algorithms.diffcoex === false) {
            this.algorithms.diffcoex = true;
            this.chosenAlgorithms.push('DiffCoEx');
            this.countSelected++;
        } else {
            this.algorithms.diffcoex = false;
            this.chosenAlgorithms.splice(this.chosenAlgorithms.indexOf('DiffCoEx', 0), 1)
            this.countSelected--;
        }
        if (this.countSelected > 1) {
            this.comboChoice = true;
        } else {
            this.comboChoice = false;
        }
        this.setSecondFormGroupValid();
    }
    modaChbChanged() {
        if (this.algorithms.moda === false) {
            this.algorithms.moda = true;
            this.chosenAlgorithms.push('Moda');
            this.countSelected++;
        } else {
            this.algorithms.moda = false;
            this.chosenAlgorithms.splice(this.chosenAlgorithms.indexOf('Moda', 0), 1)
            this.countSelected--;
        }
        if (this.countSelected > 1) {
            this.comboChoice = true;
        } else {
            this.comboChoice = false;
        }
        this.setSecondFormGroupValid();
    }
    dimeChbChanged() {
        if (this.algorithms.dime === false) {
            this.algorithms.dime = true;
            this.chosenAlgorithms.push('Dime');
            this.countSelected++;
        } else {
            this.algorithms.dime = false;
            this.chosenAlgorithms.splice(this.chosenAlgorithms.indexOf('Dime', 0), 1)
            this.countSelected--;
        }
        if (this.countSelected > 1) {
            this.comboChoice = true;
        } else {
            this.comboChoice = false;
        }
        this.setSecondFormGroupValid();
    }

    clickNextFirst(stepper: any): void {
        if (this.modifierInputObject.expressionMatrixContent === '' || this.modifierInputObject.probeMapContent === '' || (this.networkFile === '' && this.selectedNetwork === 'upload')) {
            const dialogRef = this.dialog.open(MissingDialog, {
                width: '380px',
                data: 'You need to upload the required files before moving to the next step.'
            });
            dialogRef.afterClosed().subscribe(result => {
            });
        } else {
            stepper.next();
        }
    }
    async clickNextSecond(stepper: any) {
        this.setSecondFormGroupValid();
        if (this.secondFormGroup.valid) {
            stepper.next();
            //for (let algorithm of this.chosenAlgorithms){
            //    this.result = await this.analyzeService.performAnalysis(this.modifierInputObject, algorithm);
            //    this.results.push(this.result);
            //}
            await Promise.all([
                this.analyzeService.performAnalysis(this.modifierInputObject, 'diamond', this.algorithms),
                this.analyzeService.performAnalysis(this.modifierInputObject, 'cliqueSum', this.algorithms),
                this.analyzeService.performAnalysis(this.modifierInputObject, 'mcode', this.algorithms),
                this.analyzeService.performAnalysis(this.modifierInputObject, 'md', this.algorithms),
                this.analyzeService.performAnalysis(this.modifierInputObject, 'correlationClique', this.algorithms),
                this.analyzeService.performAnalysis(this.modifierInputObject, 'moda', this.algorithms),
                this.analyzeService.performAnalysis(this.modifierInputObject, 'dime', this.algorithms),
                this.analyzeService.performAnalysis(this.modifierInputObject, 'diffCoEx', this.algorithms)
            ]).then(r => this.result = r);

            console.log('result: '+ this.result);
        }
    }
    clickNextThird(stepper: any): void {
        //if (this.samples.length > 0) {
        //    this.groupName2Ctrl.setErrors({ 'incorrect': true });
        //} else {
        //    if (this.groupName2 === '') {
        //        this.groupName2Ctrl.setErrors(null);
        //        this.groupName2Ctrl.setErrors({ 'required': true });
        //    } else {
        //        this.groupName2Ctrl.setErrors(null);
        //    }
        //}
        //if (this.groupName2 === '') {
        //    this.groupName2Ctrl.setErrors(null);
        //    this.groupName2Ctrl.setErrors({ 'required': true });
        //} else {
        //    this.groupName2Ctrl.setErrors(null);
        //}
        if (this.thirdFormGroup.valid) {
            stepper.next();
        }
    }
    clickNextFourth(stepper: any): void {
        stepper.next();
    }
    setSecondFormGroupValid() {
        if (this.countSelected > 0 && this.countSelected !== null) {
            this.algorithmCtrl.setErrors(null);
        } else {
            this.algorithmCtrl.setErrors({ 'incorrect': true });
        }
    }
}
