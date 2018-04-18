import { Routes } from '@angular/router'
import { InformationComponent } from '../information/information.component'
import { InferModuleComponent } from '../infer-module/infer-module.component'
import { AppComponent } from './app.component'

export const appRoutes: Routes = [
  { path: '', redirectTo: 'home', pathMatch: 'full' },
  { path: 'home', component: InformationComponent },
  { path: 'analyze', component: InferModuleComponent },
  { path: '**', redirectTo: 'home' },
]
