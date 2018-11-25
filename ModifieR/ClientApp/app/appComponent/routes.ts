import { Routes } from '@angular/router'
import { InformationComponent } from '../information/information.component'
import { ResultComponent } from '../result/result.component'
import { InferModuleComponent } from '../infer-module/infer-module.component'
import { ErrorComponent } from '../error/error.component'
import { AppComponent } from './app.component'

export const appRoutes: Routes = [
  { path: '', redirectTo: 'home', pathMatch: 'full' },
  { path: 'home', component: InformationComponent },
    { path: 'analyze', component: InferModuleComponent },
    { path: 'result/:id', component: ResultComponent },
    { path: 'error', component: ErrorComponent },
    { path: '**', redirectTo: 'home' },

]
