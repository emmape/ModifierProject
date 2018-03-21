
import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatStepperModule } from '@angular/material/stepper';


@Component({
    selector: 'app',
    templateUrl: './app.component.html',
    styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
    title = 'app';
    isLinear = false;
    firstFormGroup: FormGroup;
    secondFormGroup: FormGroup;

    ngOnInit() {
    }
}

