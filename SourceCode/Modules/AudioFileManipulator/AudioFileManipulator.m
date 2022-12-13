%% class to handle audio file
classdef AudioFileManipulator < handle
    %% how to use : Usage
    %   1. generate AudioFileManipulator instance
    %       -> arguments : 
    %           ・ input_file_path   :   file path to load (String)
    %           ・ output_file_path  :   file path to save (String)
    %   2. if you load file, conduct load_properties() method
    %   3. if you'd like to check properties, conduct display_properties() method
    %   4. if you'd like to normalize, conduct normalize() method
    %   5. if you'd like to change scale from norm to bits per sample, conduct change_scale() method
    %   6. if you'd like to write signal to audio file, conduct save_properties() method

    %% ---------- properties ---------- %%
    properties(Access = public)
        input_file_path;
        output_file_path;
        signal;
        sample_rate;
        information;
    end
    
    %% ---------- methods ---------- %%
    methods
        %% ---------- default constructor ---------- %%
        function object = AudioFileManipulator(input_file_path, output_file_path)
            switch nargin
                case 1
                    object.input_file_path = input_file_path;
                    object.output_file_path = "default.wav";
                case 2
                    object.input_file_path = input_file_path;
                    object.output_file_path = output_file_path;
                otherwise
                    throw(MException("Constructor:arguments", "arguments is not adjust, please input 1 or 2 arguments."));
            end
        end
        
        %% ---------- setters ---------- %%
        % input_file_path setter
        function set.input_file_path(object, input_file_path)
            if strlength(input_file_path) < 1
                thorw(MException("Setter:input_file_path", "input_file_path length is smaller than 1."));
            end
            object.input_file_path = input_file_path;
        end
        
        % output_file_path setter
        function set.output_file_path(object, output_file_path)
            if strlength(output_file_path) < 1
                thorw(MException("Setter:output_file_path", "output_file_path length is smaller than 1."));
            end
            object.output_file_path = output_file_path;
        end
        
        % signal setter
        function set.signal(object, signal)
            if length(signal) < 1
                throw(MException("Setter:signal", "signal length is smaller than 1."));
            end
            if ~isnumeric(signal)
                throw(MException("Setter:signal", "signal must be numeric array."));
            end
            object.signal = signal;
        end
        
        % sample_rate setter
        function set.sample_rate(object, sample_rate)
            if sample_rate < 1
                throw(MException("Setter:sample_rate", "sample_rate is smaller than 1."));
            end
            object.sample_rate = sample_rate;
        end

        % information setter
        function set.information(object, information)
            if ~isstruct(information)
                throw(MException("Setter:information", "information is not structure."));
            end
            object.information = information;
        end
        
        %% ---------- getters ---------- %%
        % input_file_path getter
        function input_file_path = get.input_file_path(object)
            input_file_path = object.input_file_path;
        end
        
        % output_file_path getter
        function output_file_path = get.output_file_path(object)
            output_file_path = object.output_file_path;
        end
        
        % signal getter
        function signal = get.signal(object)
            signal = object.signal;
        end
        
        % sample_rate getter
        function sample_rate = get.sample_rate(object)
            sample_rate = object.sample_rate;
        end

        % information getter
        function information = get.information(object)
            information = object.information;
        end
        
        %% ---------- usual method ---------- %%
        % method to load properties
        function load_properties(object)
            [object.signal, object.sample_rate] = audioread(object.input_file_path);
            object.information = audioinfo(object.input_file_path);
        end

        % method to normalize signal
        function normalize(object)
            object.signal = (object.signal / max(abs(object.signal)));
        end

        % method to change scale from norm to bits per sample
        function change_scale(object)
            object.normalize();
            
            if object.information.BitsPerSample == 16
                object.signal = int16(object.signal * (2 ^ (object.information.BitsPerSample - 1) - 1));
            elseif object.information.BitsPerSample == 24
                object.information.BitsPerSample = 32;
                object.signal = double(object.signal * (2 ^ (object.information.BitsPerSample - 1) - 1));
            elseif object.information.BitsPerSample == 32
                object.signal = double(object.signal * (2 ^ (object.information.BitsPerSample - 1) - 1));
            end
        end

        % method to save properties
        function save_properties(object)
            audiowrite( ...
                object.output_file_path, ...
                object.signal, ...
                object.sample_rate, ...
                "BitsPerSample", object.information.BitsPerSample, ...
                "Title", num2str(object.information.Title), ...
                "Comment", num2str(object.information.Comment), ...
                "Artist", num2str(object.information.Artist) ...
            );
        end

        % method to display properties
        function display_properties(object)
            fprintf("--------------------------------------------\n");
            fprintf("---------- Audio File Manipulator ----------\n");
            fprintf("input_file_path : %s\n", object.input_file_path);
            fprintf("output_file_path : %s\n", object.output_file_path);
            fprintf("signal shape : (%d, %d)\n", size(object.signal));
            fprintf("sample_rate: %d [Hz]\n", object.sample_rate);
            disp(object.information);
            fprintf("--------------------------------------------\n\n");
        end
    end
end