import { Component, OnInit, Inject } from '@angular/core';
import { FileUploaderComponent } from '../components/file-uploader/file-uploader.component';
import {ReadFileService} from '../services/readFile.service';
import { MissingDialog } from '../components/dialog/missingDialog.component';
import {MatDialog, MatDialogRef, MAT_DIALOG_DATA} from '@angular/material';
import {FormBuilder, FormControl, FormGroup, Validators} from '@angular/forms';


@Component({
  selector: 'app-infer-module',
  templateUrl: './infer-module.component.html',
  styleUrls: ['./infer-module.component.css']
})
export class InferModuleComponent implements OnInit {
  isLinear = true;
  selectedNetwork = '';
  diamond = false;
  mcode= false;
  md= false;
  barrenas= false;
  comboChoice= false;
  countSelected= 0;
  geneFile: any = '';
  firstFormGroup: FormGroup;
  secondFormGroup: FormGroup;
  networkFile: any = '';
  // geneFileCtrl = new FormControl('');
  networkCtrl = new FormControl('', [Validators.required]);
  algorithmCtrl = new FormControl('');

  networks = [
    {value: 'upload', viewValue: 'Upload a New Network'},
    {value: 'StringPPI', viewValue: 'String PPI'},
    {value: 'other', viewValue: 'Other PPI'}
  ];

  constructor(private readFileService: ReadFileService, public dialog: MatDialog, private _formBuilder: FormBuilder) {
    readFileService.file$.subscribe(
      file => {
        if (file.fileType === 'genes') {
          this.geneFile = file.file;
        }else if (file.fileType === 'network') {
          this.networkFile = file.file;
        }
      });
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
  }


  diamondChbChanged() {
    if (this.diamond === false) {
      this.diamond = true;
      this.countSelected ++;
    }else {
      this.diamond = false;
      this.countSelected --;
    }
     if (this.countSelected > 1) {
      this.comboChoice = true;
     }else {
       this.comboChoice = false;
     }
     this.setSecondFormGroupValid();
  }
  mcodeChbChanged() {
    if (this.mcode === false) {
      this.mcode = true;
      this.countSelected ++;
    }else {
      this.mcode = false;
      this.countSelected --;
    }
     if (this.countSelected > 1) {
      this.comboChoice = true;
     }else {
       this.comboChoice = false;
     }
     this.setSecondFormGroupValid();
  }
  mdChbChanged() {
    if (this.md === false) {
      this.md = true;
      this.countSelected ++;
    }else {
      this.md = false;
      this.countSelected --;
    }
     if (this.countSelected > 1) {
      this.comboChoice = true;
     }else {
       this.comboChoice = false;
     }
     this.setSecondFormGroupValid();
  }
  barrenasChbChanged() {
    if (this.barrenas === false) {
      this.barrenas = true;
      this.countSelected ++;
    }else {
      this.barrenas = false;
      this.countSelected --;
    }
     if (this.countSelected > 1) {
      this.comboChoice = true;
     }else {
       this.comboChoice = false;
     }
     this.setSecondFormGroupValid();
  }
  clickNextFirst(stepper: any): void {
    if (this.geneFile === '' || (this.networkFile === '' && this.selectedNetwork === 'upload') ) {
      const dialogRef = this.dialog.open(MissingDialog, {
        width: '380px',
        data: 'You need to upload the required files before moving to the next step.'
      });
      dialogRef.afterClosed().subscribe(result => {
      });
    }else {
      stepper.next();
    }
  }
  clickNextSecond(stepper: any): void {
   this.setSecondFormGroupValid();
    console.log('Second form group is:' + this.secondFormGroup.valid + ' Count: ' + this.countSelected);

    if (this.secondFormGroup.valid) {
      stepper.next();
    }
  }
  clickNextThird(stepper: any): void {
          stepper.next();
  }
  setSecondFormGroupValid() {
    if (this.countSelected > 0 && this.countSelected !== null) {
      this.algorithmCtrl.setErrors(null);
    }else {
      this.algorithmCtrl.setErrors({'incorrect': true});
    }
  }
}
