#!/usr/bin/env bash
trap 'pkill -P $$' SIGINT SIGTERM EXIT
python train_audio.py --dataset_path google_speech_commands/splitted_data --dataset_split_name train --output_name output/softmax --num_classes 12 --train_dir work/v1/ResNet2D8PoolModel-1.0/mfcc_40_3010_0.001_mom_l1 --num_silent 1854 --augmentation_method anchored_slice_or_pad_with_shift --preprocess_method mfcc --num_mfccs 40 --clip_duration_ms 1000 --window_size_ms 30 --window_stride_ms 10 --batch_size 100 --boundaries 10000 20000 --max_step_from_restore 30000 --lr_list 0.1 0.01 0.001 --absolute_schedule --no-boundaries_epoch --max_to_keep 20 --step_save_checkpoint 500 --step_evaluation 500 --optimizer mom --momentum 0.9 ResNet2D8PoolModel --weight_decay 0.001 --width_multiplier 1.0 &
sleep 5
python evaluate_audio.py --dataset_path google_speech_commands/splitted_data --dataset_split_name valid --output_name output/softmax --num_classes 12 --checkpoint_path work/v1/ResNet2D8PoolModel-1.0/mfcc_40_3010_0.001_mom_l1 --num_silent 258 --augmentation_method anchored_slice_or_pad --preprocess_method mfcc --num_mfccs 40 --clip_duration_ms 1000 --window_size_ms 30 --window_stride_ms 10 --background_frequency 0.0 --background_max_volume 0.0 --max_step_from_restore 30000 --batch_size 3 --no-shuffle --valid_type loop ResNet2D8PoolModel --weight_decay 0.001 --width_multiplier 1.0 &
wait
python evaluate_audio.py --dataset_path google_speech_commands/splitted_data --dataset_split_name test --output_name output/softmax --num_classes 12 --checkpoint_path work/v1/ResNet2D8PoolModel-1.0/mfcc_40_3010_0.001_mom_l1/valid/accuracy/valid --num_silent 257 --augmentation_method anchored_slice_or_pad --preprocess_method mfcc --num_mfccs 40 --clip_duration_ms 1000 --window_size_ms 30 --window_stride_ms 10 --background_frequency 0.0 --background_max_volume 0.0 --max_step_from_restore 30000 --batch_size 39 --no-shuffle --valid_type once ResNet2D8PoolModel --weight_decay 0.001 --width_multiplier 1.0
