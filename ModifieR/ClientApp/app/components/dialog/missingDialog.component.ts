import { Component, OnInit, Inject } from '@angular/core';
import {MatDialog, MatDialogRef, MAT_DIALOG_DATA} from '@angular/material';

@Component({
    selector: 'app-missing-dialog-component',
    templateUrl: './missingDialog.component.html',
    styleUrls: ['./missingDialog.component.css']
  })
  export class MissingDialog {
    text: string;
    constructor(
      public dialogRef: MatDialogRef<MissingDialog>,
      @Inject(MAT_DIALOG_DATA) public data: any) {
        this.text = data;
      }

    onNoClick(): void {
      this.dialogRef.close();
    }
  }
