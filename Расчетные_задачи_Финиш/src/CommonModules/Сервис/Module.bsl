
Функция ПолучитьЗначениеАктивации() Экспорт

	Возврат Константы.Активация.Получить();

КонецФункции // ПолучитьЗначениеАктивации()

Процедура АктивироватьСистему() Экспорт

	Константы.Активация.Установить(Истина);
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПриказОПриеме.Ссылка,
	|	ПриказОПриеме.Проведен
	|ИЗ
	|	Документ.ПриказОПриеме КАК ПриказОПриеме
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПриказОПриеме.МоментВремени УБЫВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПриказОбУвольнении.Ссылка,
	|	ПриказОбУвольнении.Проведен
	|ИЗ
	|	Документ.ПриказОбУвольнении КАК ПриказОбУвольнении
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НачислениеЗарплаты.Ссылка,
	|	НачислениеЗарплаты.Проведен,
	|	НачислениеЗарплаты.ПериодРегистрации
	|ИЗ
	|	Документ.НачислениеЗарплаты КАК НачислениеЗарплаты
	|
	|УПОРЯДОЧИТЬ ПО
	|	НачислениеЗарплаты.МоментВремени УБЫВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	БольничныйЛист.Ссылка,
	|	БольничныйЛист.Проведен,
	|	БольничныйЛист.ПериодРегистрации
	|ИЗ
	|	Документ.БольничныйЛист КАК БольничныйЛист
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПремияРуководителюПодразделения.Ссылка,
	|	ПремияРуководителюПодразделения.Проведен,
	|	ПремияРуководителюПодразделения.ПериодРегистрации
	|ИЗ
	|	Документ.ПремияРуководителюПодразделения КАК ПремияРуководителюПодразделения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВидыГрафиковРаботы.Ссылка,
	|	ВидыГрафиковРаботы.НедельныйГрафик
	|ИЗ
	|	Справочник.ВидыГрафиковРаботы КАК ВидыГрафиковРаботы";
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	
	Выборка = МассивРезультатов[5].Выбрать();
	
	Пока Выборка.Следующий() Цикл
	
		НаборЗаписей = РегистрыСведений.ГрафикиРаботы.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ГрафикРаботы.Установить(Выборка.Ссылка);
		НаборЗаписей.Записать();
			
		СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
		
		НачалоТекущегоГода = НачалоГода(ТекущаяДата());
		Интервал = Новый Структура("ДатаНачала,ДатаОкончания", ДобавитьМесяц(НачалоТекущегоГода, - 12), ДобавитьМесяц(НачалоТекущегоГода, 24));
		
		Если Выборка.НедельныйГрафик Тогда
			
			СправочникОбъект.ЗаполнитьКалендарьЗаИнтервал(Интервал)	
		
		Иначе
			
			СправочникОбъект.ЗаполнитьКалендарь_ПоВременнойСхеме(Интервал)	
		
		КонецЕсли;
		
	КонецЦикла;
	
	
	
	//--Приказ о приеме
	
	Выборка = МассивРезультатов[0].Выбрать();
	
	Пока Выборка.Следующий() Цикл

		ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
		
		ДокументОбъект.Дата = ДобавитьМесяц(НачалоМесяца(ТекущаяДата()),-1) + 1;
		ДокументОбъект.ДатаСобытия = ДокументОбъект.Дата + 24*60*60*4;
		
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		
	КонецЦикла;
	
	Выборка = МассивРезультатов[1].Выбрать();
	
	Пока Выборка.Следующий() Цикл

		ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
		
		ДокументОбъект.Дата = ДобавитьМесяц(НачалоМесяца(ТекущаяДата()),-1);
		ДокументОбъект.ДатаСобытия = ДокументОбъект.Дата + 24*60*60*3;
		
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		
	КонецЦикла;

	//----Больничный---
	
	
	Выборка = МассивРезультатов[3].Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Константы.ТекущийПериод.Установить(Выборка.ПериодРегистрации);

		ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ДокументОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		
		НачалоТекущегоМесяца = НачалоМесяца(ТекущаяДата());
		Константы.ТекущийПериод.Установить(НачалоТекущегоМесяца);
		
		ДокументОбъект.Дата = ТекущаяДата();
		ДокументОбъект.ДатаОкончания = ТекущаяДата();
		ДокументОбъект.ДатаНачала = Макс(НачалоТекущегоМесяца,(ДокументОбъект.ДатаОкончания  - 24*60*60*10));
		ДокументОбъект.ПериодРегистрации = НачалоМесяца(ТекущаяДата());
			
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		
		
	КонецЕсли;;
	
	
	Выборка = МассивРезультатов[2].Выбрать();
	
	Дата = НачалоМесяца(ТекущаяДата())+ 24*60*60*5;
	
	ПериодРегистрации =  ДобавитьМесяц(НачалоМесяца(ТекущаяДата()),-1);
	ТекущийПериод = ПериодРегистрации;
	
	Пока Выборка.Следующий() Цикл

		ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
		Константы.ТекущийПериод.Установить(ДокументОбъект.ПериодРегистрации);
		ДокументОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения); 
		
		Константы.ТекущийПериод.Установить(ПериодРегистрации);
		ДокументОбъект.Дата = Дата;
		ДокументОбъект.ПериодРегистрации = ПериодРегистрации;
		
		ДокументОбъект.Объект_ЗаполнитьТЧ();
		
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		
		Дата = ДобавитьМесяц(Дата, -1);
		ПериодРегистрации =  ДобавитьМесяц(ПериодРегистрации,-1);
		
	КонецЦикла;
	
	Константы.ТекущийПериод.Установить(ТекущийПериод);

	
	Выборка = МассивРезультатов[4].Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
		
		НачалоТекущегоМесяца = НачалоМесяца(ТекущаяДата());
		
		ДокументОбъект.Дата = ТекущаяДата();
		ДокументОбъект.ПериодРегистрации = НачалоТекущегоМесяца;
			
		ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
		
		
	КонецЦикла;
	


КонецПроцедуры
