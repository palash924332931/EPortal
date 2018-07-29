import { Component, Input} from '@angular/core';
import {Level} from './territorydefinition.model';


@Component({
    selector: 'levelview',
    templateUrl: '../../app/territorydefinition/levelview.component.html'
})
export class LevelViewComponent {
    @Input() rootlevel: Level = new Level(0, 'test data');
}