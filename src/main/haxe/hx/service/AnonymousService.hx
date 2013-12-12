package hx.service;

import rx.Future;

import hx.ifs.Service in IService;

class AnonymousService implements IService{
  public function new(_apply){
    this._apply = _apply;
  }
  public dynamic function _apply(v:I):Future<Unit>{

  }
  public function apply(v:I):Future<O>{
    retu
  }
}