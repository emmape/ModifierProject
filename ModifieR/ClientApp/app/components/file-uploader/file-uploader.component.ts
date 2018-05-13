import { Component, Input, OnInit } from '@angular/core';
import { ReadFileService } from '../../services/readFile.service';
import { ReadFile } from '../../models/readFile.model';
import { AnalyzeService } from '../../services/analyze.service';

@Component({
    selector: 'app-file-uploader',
    templateUrl: 'file-uploader.component.html',
    styleUrls: ['./file-uploader.component.css']
    //  inputs:['activeColor','baseColor','overlayColor']
})
export class FileUploaderComponent implements OnInit {
    @Input() filetype: string='';
    activeColor = 'green';
    baseColor = '#ccc';
    overlayColor = 'rgba(255,255,255,0.5)';

    dragging = false;
    loaded = false;
    fileLoaded = false;
    inputFile = '';
    fileColor: any;
    borderColor: any;
    iconColor: any;
    filename = 'Drag a file here';

    constructor(private readFileService: ReadFileService, public analyzeService: AnalyzeService) { }
    ngOnInit() {

    }
    handleDragEnter() {
        this.dragging = true;
    }

    handleDragLeave() {
        this.dragging = false;
    }

    handleDrop(e: any) {
        e.preventDefault();
        this.dragging = false;
        this.handleInputChange(e);
    }

    handleFileLoad() {
        this.fileLoaded = true;
        this.iconColor = this.overlayColor;
    }

    async handleInputChange(e: any) {
        console.log(this.filetype);
        const file = e.dataTransfer ? e.dataTransfer.files[0] : e.target.files[0];
        const pattern = /.csv*/;
        const reader = new FileReader();
        if (!file.name.match(pattern)) {
            alert('Invalid File Format, please upload a ' + pattern + ' file');
            return;
        }
        this.loaded = false;

        //if (this.filetype === 'genes') {
        //    var resp = await this.inputParametersService.inputExpressionMatrix(file);
        //    this.readFileService.samplesRecieved(resp);
        //} else if (this.filetype === 'probeMap') {
        //    var resp = await this.inputParametersService.inputProbeMap(file);
        //}

        reader.onload = this._handleReaderLoaded.bind(this);
        reader.readAsText(file);
        this.filename = file.name;
        this.fileLoaded = true;
    }

    _handleReaderLoaded(e: any) {
        const reader = e.target;
        this.inputFile = reader.result;
        this.loaded = true;
        const f: ReadFile = { fileType: this.filetype, file: this.inputFile };
        this.readFileService.fileUploaded(f);
    }

    _setActive() {
        this.borderColor = this.activeColor;
        if (this.inputFile.length === 0) {
            this.iconColor = this.activeColor;
        }
    }

    _setInactive() {
        this.borderColor = this.baseColor;
        if (this.inputFile.length === 0) {
            this.iconColor = this.baseColor;
        }
    }

}
