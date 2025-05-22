New-Variable -Option Constant -Name WORK_DAYS_PER_WEEK -Value 5;$realDaysPerIdealDay=
4;$numberOfTasks=34;$sum=0;for($j=0;$j -lt $NumberOfTasks;$j++){$realTaskDays=
$taskEstimate[$j]*$realDaysPerIdealDay;$realTaskWeeks=$realTaskDays/
$WORK_DAYS_PER_WEEK;$sum+=$realTaskWeeks}
