import {LightningElement,api,track} from 'lwc';
import uploadFiles from '@salesforce/apex/SampleDataController.uploadFiles';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SampleDataImporter extends LightningElement {

    @track filesUploaded = [];

    handleFileUploaded(event) {
        if (event.target.files.length > 0) {
            let files = [];
            for(var i=0; i< event.target.files.length; i++){
                let file = event.target.files[i];
                let reader = new FileReader();
                reader.onload = e => {
                    //let base64 = 'base64,';
                    //let content = reader.result.indexOf(base64) + base64.length;
                    //let fileContents = reader.result.substring(content);
                    let fileContents = reader.result;
                    this.filesUploaded.push({Title: file.name, Content: fileContents});
                };
                reader.readAsText(file);
            }
        }
    }

    attachFiles(event){
        uploadFiles({files: this.filesUploaded})
            .then(result => {
                if(result == true) {
                    this.showToastMessage('Success','Files uploaded', 'success');
                }else{
                    this.showToastMessage('Error','Error uploading files', 'error');
                }
                this.filesUploaded = [];
            })
            .catch(error => {
                this.showToastMessage('Error','Error uploading files', 'error');
            });
    }

    showToastMessage(title,message,variant){
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant
            })
        );
    }
}